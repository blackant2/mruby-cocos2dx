#include <stdlib.h>
#include <stdio.h>
#include <zlib.h>
#include <sys/stat.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <string.h>
extern "C" {
#include "mruby.h"
#include "mruby/value.h"
#include "mruby/string.h"
#include "mruby/array.h"
#include "mruby/class.h"
#include "mruby/numeric.h"
#include "mruby/string.h"
#include "mruby/variable.h"
}
#include "base/ccConfig.h"
#include "cocos2d.h"
#include "unzip.h"
#include "platform/CCFileUtils.h"
/*
 ** pack.c - Array#pack, String#unpack
 */






#define UNZIP_BUFFER_SIZE    8192
#define UNZIP_MAX_FILENAME   512

extern bool rubyval_to_std_string(mrb_state* mrb, mrb_value arg, std::string* outValue, const char* funcName = "");

using namespace cocos2d;

bool unzip_createDirectory(const char *path)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT) || (CC_TARGET_PLATFORM == CC_PLATFORM_WP8)
    return FileUtils::getInstance()->createDirectory(path);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    BOOL ret = CreateDirectoryA(path, nullptr);
    if (!ret && ERROR_ALREADY_EXISTS != GetLastError())
    {
        return false;
    }
    return true;
#else
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST))
    {
        return false;
    }

    return true;
#endif


}


static voidpf
zlib_alloc(voidpf opaque, uInt n, uInt size)
{
  return calloc((size_t) n, (size_t) size);
}

static void
zlib_free(voidpf opaque, voidpf p)
{
  free((void *) p);
}

static mrb_value
mrb_zlib_raise(mrb_state *mrb, z_streamp strm, int err)
{
  char msg[256];
  snprintf(msg, 256, "zlib error (%d): %s", err, strm->msg);
  mrb_raise(mrb, E_RUNTIME_ERROR, msg);
  return mrb_nil_value();
}

static mrb_value
ruby_cocos2dx_zlib_deflate_static(mrb_state *mrb, mrb_value self)
{
  struct RString *result;
  mrb_value value_data, value_result = mrb_nil_value();
  z_stream strm;
  int res;

  mrb_get_args(mrb, "S", &value_data);

  strm.zalloc = zlib_alloc;
  strm.zfree = zlib_free;
  strm.opaque = NULL;

  res = deflateInit(&strm, Z_DEFAULT_COMPRESSION);
  if (res != Z_OK) {
    mrb_zlib_raise(mrb, &strm, res);
  }

  value_result = mrb_str_buf_new(mrb,
      deflateBound(&strm, RSTRING_LEN(value_data)));
  result = mrb_str_ptr(value_result);

  strm.next_in = (Bytef *) RSTRING_PTR(value_data);
  strm.avail_in = RSTRING_LEN(value_data);
  strm.next_out = (Bytef *) RSTRING_PTR(value_result);
  strm.avail_out = RSTRING_CAPA(value_result);

  while (1) {
    res = deflate(&strm, Z_FINISH);
    if (res == Z_OK) {
      value_result = mrb_str_resize(mrb, value_result,
          RSTRING_CAPA(value_result) * 2);
      strm.next_out = (Bytef *) RSTRING_PTR(value_result) + strm.total_out;
      strm.avail_out = RSTRING_CAPA(value_result) - strm.total_out;
    }
    else if (res == Z_STREAM_END) {
      result->as.heap.len = strm.total_out;
      *(result->as.heap.ptr + result->as.heap.len) = '\0';

      res = deflateEnd(&strm);
      if (res != Z_OK) {
        mrb_zlib_raise(mrb, &strm, res);
      }
      break;
    }
    else {
      mrb_zlib_raise(mrb, &strm, res);
    }
  }

  return value_result;
}

static mrb_value
ruby_cocos2dx_zlib_inflate_static(mrb_state *mrb, mrb_value self)
{
  struct RString *result;
  mrb_value value_data, value_result = mrb_nil_value();
  z_stream strm;
  int res;

  mrb_get_args(mrb, "S", &value_data);

  strm.zalloc = zlib_alloc;
  strm.zfree = zlib_free;
  strm.opaque = NULL;
  strm.next_in = (Bytef *) RSTRING_PTR(value_data);
  strm.avail_in = RSTRING_LEN(value_data);

  res = inflateInit(&strm);
  if (res != Z_OK) {
    mrb_zlib_raise(mrb, &strm, res);
  }

  value_result = mrb_str_buf_new(mrb, RSTRING_LEN(value_data));
  result = mrb_str_ptr(value_result);

  strm.next_out = (Bytef *) RSTRING_PTR(value_result);
  strm.avail_out = RSTRING_CAPA(value_result);

  while (1) {
    res = inflate(&strm, Z_NO_FLUSH);
    if (res == Z_OK) {
      value_result = mrb_str_resize(mrb, value_result,
          RSTRING_CAPA(value_result) * 2);
      strm.next_out = (Bytef *) RSTRING_PTR(value_result) + strm.total_out;
      strm.avail_out = RSTRING_CAPA(value_result) - strm.total_out;
    }
    else if (res == Z_STREAM_END) {
      result->as.heap.len = strm.total_out;
      *(result->as.heap.ptr + result->as.heap.len) = '\0';

      res = inflateEnd(&strm);
      if (res != Z_OK) {
        mrb_zlib_raise(mrb, &strm, res);
      }
      break;
    }
    else {
      mrb_zlib_raise(mrb, &strm, res);
    }
  }

  return value_result;
}

mrb_value ruby_cocos2dx_zlib_unzip_static(mrb_state* mrb, mrb_value self){
    mrb_value* argv;
    int argc;
    mrb_get_args(mrb, "*", &argv, &argc);

    bool ok = true;
    mrb_value mrbfalse=mrb_bool_value((mrb_bool)false);
    do {
        if (argc == 2) {
          const char* arg0;
          std::string arg0_tmp; 
          ok = rubyval_to_std_string(mrb, argv[0], &arg0_tmp, "CC::Zlib:unzip"); 
          if (!ok) { break; }
          arg0 = arg0_tmp.c_str();
          
          const char* arg1;
          std::string arg1_tmp; 
          ok = rubyval_to_std_string(mrb, argv[1], &arg1_tmp, "CC::Zlib.unzip"); 
          if (!ok) { break; }
          if (arg1_tmp[arg1_tmp.length()-1] != '/'){
              arg1_tmp=arg1_tmp+'/';
          }
          arg1 = arg1_tmp.c_str();
          unzFile zipfile = unzOpen(arg0);
          if (! zipfile)
          {
             mrb_raise(mrb, E_RUNTIME_ERROR, "can not open zip file : CC::Zlib.unzip");
             return mrbfalse;
          }

          unz_global_info global_info;
          if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
          {
              mrb_raise(mrb, E_RUNTIME_ERROR, "can not read file global info : CC::Zlib.unzip");
              unzClose(zipfile);
              return mrbfalse;
          }

          char readBuffer[UNZIP_BUFFER_SIZE];

          uLong i;
          for (i = 0; i < global_info.number_entry; ++i)
          {
              // Get info about current file.
              unz_file_info fileInfo;
              char fileName[UNZIP_MAX_FILENAME];
              if (unzGetCurrentFileInfo(zipfile,
                                  &fileInfo,
                                  fileName,
                                  UNZIP_MAX_FILENAME,
                                  nullptr,
                                  0,
                                  nullptr,
                                  0) != UNZ_OK)
              {
                  mrb_raise(mrb, E_RUNTIME_ERROR, "can not read file info : CC::Zlib.unzip");
                  unzClose(zipfile);
                  return mrbfalse;
              }
              const std::string fullPath = arg1_tmp + fileName;
              const size_t filenameLength = strlen(fileName);
              if (fileName[filenameLength-1] == '/')
              {
                  // 创建目录
                  if (!unzip_createDirectory(fullPath.c_str()))
                  {
                      mrb_raise(mrb, E_RUNTIME_ERROR, "can not create directory  : CC::Zlib.unzip");
                      unzClose(zipfile);
                      return mrbfalse;
                  }
              }
               else
            {
                //如果不存在目录则创建
                const std::string fileNameStr(fileName);
                
                size_t startIndex=0;
                
                size_t index=fileNameStr.find("/",startIndex);
                
                while(index != std::string::npos)
                {
                    const std::string dir=arg1_tmp+fileNameStr.substr(0,index);
                    
                    FILE *out = fopen(dir.c_str(), "r");
                    
                    if(!out)
                    {
                        if (!unzip_createDirectory(dir.c_str()))
                        {
                            mrb_raise(mrb, E_RUNTIME_ERROR, "can not create directory  : CC::Zlib.unzip");
                            unzClose(zipfile);
                            return mrbfalse;
                        }
                    }
                    else
                    {
                        fclose(out);
                    }
                    
                    startIndex=index+1;
                    
                    index=fileNameStr.find("/",startIndex);
                  }  //npos.each 每一个分隔符 

                  if (unzOpenCurrentFile(zipfile) != UNZ_OK)
                  {
                      mrb_raise(mrb, E_RUNTIME_ERROR, "can not open file  : CC::Zlib.unzip");
                      unzClose(zipfile);
                      return mrbfalse;
                  }
                  
                
                  FILE *out = fopen(fullPath.c_str(), "wb");
                  if (! out)
                  {
                      mrb_raise(mrb, E_RUNTIME_ERROR, "can not open destination file  : CC::Zlib.unzip");
                      unzCloseCurrentFile(zipfile);
                      unzClose(zipfile);
                      return mrbfalse;
                  }

                    int error = UNZ_OK;
                    do
                    {
                        error = unzReadCurrentFile(zipfile, readBuffer, UNZIP_BUFFER_SIZE);
                        if (error < 0)
                        {
                            mrb_raise(mrb, E_RUNTIME_ERROR, "can not  read zip file  : CC::Zlib.unzip");
                            unzCloseCurrentFile(zipfile);
                            unzClose(zipfile);
                            return mrbfalse;
                        }
                        
                        if (error > 0)
                        {
                            fwrite(readBuffer, error, 1, out);
                        }
                    } while(error > 0);
                    
                    fclose(out);


                }  //如果是目录/文件
            
                 unzCloseCurrentFile(zipfile);
        
                  // 下一个文件
                  if ((i+1) < global_info.number_entry)
                  {
                      if (unzGoToNextFile(zipfile) != UNZ_OK)
                      {
                          mrb_raise(mrb, E_RUNTIME_ERROR, "can not read next file  : CC::Zlib.unzip");
                          unzClose(zipfile);
                          return mrbfalse;
                      }
                  }

            }// global_info.each
            unzClose(zipfile);
            return mrb_bool_value((mrb_bool)true);;
        } //argc==2
    }while (0);
    mrb_raise(mrb, E_RUNTIME_ERROR, "undefined static method : cocos2d::Zlib#unzip");

    return mrbfalse;
}


struct tmpl {
  mrb_value str;
  int idx;
};

enum {
  PACK_DIR_CHAR,  /* C */
  PACK_DIR_SHORT, /* S */
  PACK_DIR_LONG,  /* L */
  PACK_DIR_QUAD,  /* Q */
  //PACK_DIR_INT, /* i */
  //PACK_DIR_VAX,
  //PACK_DIR_UTF8,  /* U */
  //PACK_DIR_BER,
  PACK_DIR_DOUBLE,  /* E */
  PACK_DIR_FLOAT, /* f */
  PACK_DIR_STR,   /* A */
  PACK_DIR_HEX,   /* h */
  PACK_DIR_BASE64,  /* m */
  PACK_DIR_INVALID
};

enum {
  PACK_TYPE_INTEGER,
  PACK_TYPE_FLOAT,
  PACK_TYPE_STRING,
  PACK_TYPE_NONE
};

#define PACK_FLAG_s             0x00000001  /* native size ("_" "!") */
#define PACK_FLAG_a             0x00000002  /* null padding ("a") */
#define PACK_FLAG_Z             0x00000004  /* append nul char ("z") */
#define PACK_FLAG_SIGNED        0x00000008  /* native size ("_" "!") */
#define PACK_FLAG_GT            0x00000010  /* big endian (">") */
#define PACK_FLAG_LT            0x00000020  /* little endian ("<") */
#define PACK_FLAG_WIDTH         0x00000040  /* "count" is "width" */
#define PACK_FLAG_LSB           0x00000080  /* LSB / low nibble first */
#define PACK_FLAG_COUNT2        0x00000100  /* "count" is special... */
#define PACK_FLAG_LITTLEENDIAN  0x00000200  /* little endian actually */

#define PACK_BASE64_IGNORE  0xff
#define PACK_BASE64_PADDING 0xfe

static int littleendian = 0;

const static unsigned char base64chars[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static signed char base64_dec_tab[128];


static int
check_little_endian(void)
{
  unsigned int n = 1;
  return (*(unsigned char *)&n == 1);
}

static unsigned int
hex2int(unsigned char ch)
{
  if (ch >= '0' && ch <= '9') 
    return ch - '0';
  else if (ch >= 'A' && ch <= 'F')
    return 10 + (ch - 'A');
  else if (ch >= 'a' && ch <= 'f')
    return 10 + (ch - 'a');
  else
    return 0;
}

static void
make_base64_dec_tab(void)
{
  int i;
  memset(base64_dec_tab, PACK_BASE64_IGNORE, sizeof(base64_dec_tab));
  for (i = 0; i < 26; i++)
    base64_dec_tab['A' + i] = i;
  for (i = 0; i < 26; i++)
    base64_dec_tab['a' + i] = i + 26;
  for (i = 0; i < 10; i++)
    base64_dec_tab['0' + i] = i + 52;
  base64_dec_tab['+'] = 62;
  base64_dec_tab['/'] = 63;
  base64_dec_tab['='] = PACK_BASE64_PADDING;
}

static mrb_value
str_len_ensure(mrb_state *mrb, mrb_value str, int len)
{
  int n = RSTRING_LEN(str);
  if (len > n) {
    do {
      n *= 2;
    } while (len > n);
    str = mrb_str_resize(mrb, str, n);
  }
  return str;
}


static int
pack_c(mrb_state *mrb, mrb_value o, mrb_value str, mrb_int sidx, unsigned int flags)
{
  str = str_len_ensure(mrb, str, sidx + 1);
  RSTRING_PTR(str)[sidx] = mrb_fixnum(o);
  return 1;
}

static int
unpack_c(mrb_state *mrb, const void *src, int srclen, mrb_value ary, unsigned int flags)
{
  if (flags & PACK_FLAG_SIGNED)
    mrb_ary_push(mrb, ary, mrb_fixnum_value(*(signed char *)src));
  else
    mrb_ary_push(mrb, ary, mrb_fixnum_value(*(unsigned char *)src));
  return 1;
}

static int
pack_s(mrb_state *mrb, mrb_value o, mrb_value str, mrb_int sidx, unsigned int flags)
{
  unsigned short n;

  str = str_len_ensure(mrb, str, sidx + 2);
  n = mrb_fixnum(o);
  if (flags & PACK_FLAG_LITTLEENDIAN) {
    RSTRING_PTR(str)[sidx+0] = n % 256;
    RSTRING_PTR(str)[sidx+1] = n / 256;
  } else {
    RSTRING_PTR(str)[sidx+0] = n / 256;
    RSTRING_PTR(str)[sidx+1] = n % 256;
  }
  return 2;
}

static int
unpack_s(mrb_state *mrb, const unsigned char *src, int srclen, mrb_value ary, unsigned int flags)
{
  int n;

  if (flags & PACK_FLAG_LITTLEENDIAN) {
    n = src[1] * 256 + src[0];
  } else {
    n = src[0] * 256 + src[1];
  }
  if ((flags & PACK_FLAG_SIGNED) && (n >= 0x8000)) {
    n -= 0x10000;
  }
  mrb_ary_push(mrb, ary, mrb_fixnum_value(n));
  return 2;
}

static int
pack_l(mrb_state *mrb, mrb_value o, mrb_value str, mrb_int sidx, unsigned int flags)
{
  unsigned long n;
  str = str_len_ensure(mrb, str, sidx + 4);
  n = mrb_fixnum(o);
  if (flags & PACK_FLAG_LITTLEENDIAN) {
    RSTRING_PTR(str)[sidx+0] = n & 0xff;
    RSTRING_PTR(str)[sidx+1] = n >> 8;
    RSTRING_PTR(str)[sidx+2] = n >> 16;
    RSTRING_PTR(str)[sidx+3] = n >> 24;
  } else {
    RSTRING_PTR(str)[sidx+0] = n >> 24;
    RSTRING_PTR(str)[sidx+1] = n >> 16;
    RSTRING_PTR(str)[sidx+2] = n >> 8;
    RSTRING_PTR(str)[sidx+3] = n & 0xff;
  }
  return 4;
}

static int
unpack_l(mrb_state *mrb, const unsigned char *src, int srclen, mrb_value ary, unsigned int flags)
{
  char msg[60];
  uint32_t ul;
  mrb_int n;

  if (flags & PACK_FLAG_LITTLEENDIAN) {
    ul = (uint32_t)src[3] * 256*256*256;
    ul += (uint32_t)src[2] *256*256;
    ul += (uint32_t)src[1] *256;
    ul += (uint32_t)src[0];
  } else {
    ul = (uint32_t)src[0] * 256*256*256;
    ul += (uint32_t)src[1] *256*256;
    ul += (uint32_t)src[2] *256;
    ul += (uint32_t)src[3];
  }
  if (flags & PACK_FLAG_SIGNED) {
    int32_t sl = ul;
    if (!FIXABLE(sl)) {
      snprintf(msg, sizeof(msg), "cannot unpack to Fixnum: %ld", (long)sl);
      mrb_raise(mrb, E_RANGE_ERROR, msg);
    }
    n = sl;
  } else {
    if (!POSFIXABLE(ul)) {
      snprintf(msg, sizeof(msg), "cannot unpack to Fixnum: %lu", (unsigned long)ul);
      mrb_raise(mrb, E_RANGE_ERROR, msg);
    }
    n = ul;
  }
  mrb_ary_push(mrb, ary, mrb_fixnum_value(n));
  return 4;
}

static int
pack_q(mrb_state *mrb, mrb_value o, mrb_value str, mrb_int sidx, unsigned int flags)
{
  unsigned long long n;
  str = str_len_ensure(mrb, str, sidx + 8);
  n = mrb_fixnum(o);
  if (flags & PACK_FLAG_LITTLEENDIAN) {
    RSTRING_PTR(str)[sidx+0] = n & 0xff;
    RSTRING_PTR(str)[sidx+1] = n >> 8;
    RSTRING_PTR(str)[sidx+2] = n >> 16;
    RSTRING_PTR(str)[sidx+3] = n >> 24;
    RSTRING_PTR(str)[sidx+4] = n >> 32;
    RSTRING_PTR(str)[sidx+5] = n >> 40;
    RSTRING_PTR(str)[sidx+6] = n >> 48;
    RSTRING_PTR(str)[sidx+7] = n >> 56;
  } else {
    RSTRING_PTR(str)[sidx+0] = n >> 56;
    RSTRING_PTR(str)[sidx+1] = n >> 48;
    RSTRING_PTR(str)[sidx+2] = n >> 40;
    RSTRING_PTR(str)[sidx+3] = n >> 32;
    RSTRING_PTR(str)[sidx+4] = n >> 24;
    RSTRING_PTR(str)[sidx+5] = n >> 16;
    RSTRING_PTR(str)[sidx+6] = n >> 8;
    RSTRING_PTR(str)[sidx+7] = n & 0xff;
  }
  return 8;
}

static int
unpack_q(mrb_state *mrb, const unsigned char *src, int srclen, mrb_value ary, unsigned int flags)
{
  char msg[60];
  uint64_t ull;
  int i, pos, step;
  mrb_int n;

  if (flags & PACK_FLAG_LITTLEENDIAN) {
    pos  = 7;
    step = -1;
  } else {
    pos  = 0;
    step = 1;
  }
  ull = 0;
  for (i = 0; i < 8; i++) {
    ull = ull * 256 + (uint64_t)src[pos];
    pos += step;
  }
  if (flags & PACK_FLAG_SIGNED) {
    int64_t sll = ull;
    if (!FIXABLE(sll)) {
      snprintf(msg, sizeof(msg), "cannot unpack to Fixnum: %lld", (long long)sll);
      mrb_raise(mrb, E_RANGE_ERROR, msg);
    }
    n = sll;
  } else {
    if (!POSFIXABLE(ull)) {
      snprintf(msg, sizeof(msg), "cannot unpack to Fixnum: %llu", (unsigned long long)ull);
      mrb_raise(mrb, E_RANGE_ERROR, msg);
    }
    n = ull;
  }
  mrb_ary_push(mrb, ary, mrb_fixnum_value(n));
  return 8;
}

static int
pack_double(mrb_state *mrb, mrb_value o, mrb_value str, mrb_int sidx, unsigned int flags)
{
  int i;
  double d;
  uint8_t *buffer = (uint8_t *)&d;
  str = str_len_ensure(mrb, str, sidx + 8);
  d = mrb_float(o);

  if (flags & PACK_FLAG_LITTLEENDIAN) {
#ifdef MRB_ENDIAN_BIG
    for (i = 0; i < 8; ++i) {
      RSTRING_PTR(str)[sidx + i] = buffer[8 - i - 1];
    }
#else
    memcpy(RSTRING_PTR(str) + sidx, buffer, 8);
#endif
  } else {
#ifdef MRB_ENDIAN_BIG
    memcpy(RSTRING_PTR(str) + sidx, buffer, 8);
#else
    for (i = 0; i < 8; ++i) {
      RSTRING_PTR(str)[sidx + i] = buffer[8 - i - 1];
    }
#endif
  }

  return 8;
}

static int
unpack_double(mrb_state *mrb, const unsigned char * src, int srclen, mrb_value ary, unsigned int flags)
{
  int i;
  double d;
  uint8_t *buffer = (uint8_t *)&d;

  if (flags & PACK_FLAG_LITTLEENDIAN) {
#ifdef MRB_ENDIAN_BIG
    for (i = 0; i < 8; ++i) {
      buffer[8 - i - 1] = src[i];
    }
#else
    memcpy(buffer, src, 8);
#endif
  } else {
#ifdef MRB_ENDIAN_BIG
    memcpy(buffer, src, 8);
#else
    for (i = 0; i < 8; ++i) {
      buffer[8 - i - 1] = src[i];
    }
#endif
  }
  mrb_ary_push(mrb, ary, mrb_float_value(mrb, d));

  return 8;
}

static int
pack_float(mrb_state *mrb, mrb_value o, mrb_value str, mrb_int sidx, unsigned int flags)
{
  int i;
  float f;
  uint8_t *buffer = (uint8_t *)&f;
  str = str_len_ensure(mrb, str, sidx + 4);
  f = mrb_float(o);

  if (flags & PACK_FLAG_LITTLEENDIAN) {
#ifdef MRB_ENDIAN_BIG
    for (i = 0; i < 4; ++i) {
      RSTRING_PTR(str)[sidx + i] = buffer[4 - i - 1];
    }
#else
    memcpy(RSTRING_PTR(str) + sidx, buffer, 4);
#endif
  } else {
#ifdef MRB_ENDIAN_BIG
    memcpy(RSTRING_PTR(str) + sidx, buffer, 4);
#else
    for (i = 0; i < 4; ++i) {
      RSTRING_PTR(str)[sidx + i] = buffer[4 - i - 1];
    }
#endif
  }

  return 4;
}

static int
unpack_float(mrb_state *mrb, const unsigned char * src, int srclen, mrb_value ary, unsigned int flags)
{
  int i;
  float f;
  uint8_t *buffer = (uint8_t *)&f;

  if (flags & PACK_FLAG_LITTLEENDIAN) {
#ifdef MRB_ENDIAN_BIG
    for (i = 0; i < 4; ++i) {
      buffer[4 - i - 1] = src[i];
    }
#else
    memcpy(buffer, src, 4);
#endif
  } else {
#ifdef MRB_ENDIAN_BIG
    memcpy(buffer, src, 4);
#else
    for (i = 0; i < 4; ++i) {
      buffer[4 - i - 1] = src[i];
    }
#endif
  }
  mrb_ary_push(mrb, ary, mrb_float_value(mrb, f));

  return 4;
}

static int
pack_a(mrb_state *mrb, mrb_value src, mrb_value dst, mrb_int didx, long count, unsigned int flags)
{
  int copylen, slen, padlen;
  char *dptr, *dptr0, pad, *sptr;

  sptr = RSTRING_PTR(src);
  slen = RSTRING_LEN(src);

  if ((flags & PACK_FLAG_a) || (flags & PACK_FLAG_Z))
    pad = '\0';
  else
    pad = ' ';

  if (count == 0) {
    return 0;
  } else if (count == -1) {
    copylen = slen;
    padlen = (flags & PACK_FLAG_Z) ? 1 : 0;
  } else if (count < slen) {
    copylen = count;
    padlen = 0;
  } else {
    copylen = slen;
    padlen = count - slen;
  }

  dst = str_len_ensure(mrb, dst, didx + copylen + padlen);
  dptr0 = dptr = RSTRING_PTR(dst) + didx;
  memcpy(dptr, sptr, copylen);
  dptr += copylen;
  while (padlen-- > 0) {
    *dptr++ = pad;
  }
 
  return dptr - dptr0;
}

static int
unpack_a(mrb_state *mrb, const void *src, int slen, mrb_value ary, long count, unsigned int flags)
{
  mrb_value dst;
  const char *cp, *sptr;
  long copylen;

  sptr =(char *) src;
  if (count != -1 && count < slen)  {
    slen = count;
  }
  copylen = slen;

  if (flags & PACK_FLAG_Z) {  /* "Z" */
    if ((cp = (char*)memchr(sptr, '\0', slen)) != NULL) {
      copylen = cp - sptr;
      if (count == -1) {
        slen = copylen + 1;
      }
    }
  } else if (!(flags & PACK_FLAG_a)) {  /* "A" */
    while (copylen > 0 && (sptr[copylen - 1] == '\0' || isspace(sptr[copylen - 1]))) {
      copylen--;
    }
  }

  dst = mrb_str_new(mrb, sptr, copylen);
  mrb_ary_push(mrb, ary, dst);
  return slen;
}


static int
pack_h(mrb_state *mrb, mrb_value src, mrb_value dst, mrb_int didx, long count, unsigned int flags)
{
  unsigned int a, ashift, b, bshift;
  int slen;
  char *dptr, *dptr0, *sptr;

  sptr = RSTRING_PTR(src);
  slen = RSTRING_LEN(src);

  if (flags & PACK_FLAG_LSB) {
    ashift = 0;
    bshift = 4;
  } else {
    ashift = 4;
    bshift = 0;
  }

  if (count == -1) {
    count = slen;
  } else if (slen > count) {
    slen = count;
  }
    
  dst = str_len_ensure(mrb, dst, didx + count);
  dptr = RSTRING_PTR(dst) + didx;

  dptr0 = dptr;
  for (; count > 0; count -= 2) {
    a = b = 0;
    if (slen > 0) {
      a = hex2int(*sptr++);
      slen--;
    }
    if (slen > 0) {
      b = hex2int(*sptr++);
      slen--;
    }
    *dptr++ = (a << ashift) + (b << bshift);
  }

  return dptr - dptr0;
}

static int
unpack_h(mrb_state *mrb, const void *src, int slen, mrb_value ary, int count, unsigned int flags)
{
  mrb_value dst;
  int a, ashift, b, bshift;
  const char *sptr, *sptr0;
  char *dptr, *dptr0;
  const char hexadecimal[] = "0123456789abcdef";

  if (flags & PACK_FLAG_LSB) {
    ashift = 0;
    bshift = 4;
  } else {
    ashift = 4;
    bshift = 0;
  }

  sptr = (char *)src;

  if (count == -1)
    count = slen * 2;

  dst = mrb_str_new(mrb, NULL, count);
  dptr = RSTRING_PTR(dst);

  sptr0 = sptr;
  dptr0 = dptr;
  while (slen > 0 && count > 0) {
    a = (*sptr >> ashift) & 0x0f;
    b = (*sptr >> bshift) & 0x0f;
    sptr++;
    slen--;

    *dptr++ = hexadecimal[a];
    count--;

    if (count > 0) {
      *dptr++ = hexadecimal[b];
      count--;
    }
  }

  dst = mrb_str_resize(mrb, dst, dptr - dptr0);
  mrb_ary_push(mrb, ary, dst);
  return sptr - sptr0;
}


static int
pack_m(mrb_state *mrb, mrb_value src, mrb_value dst, mrb_int didx, long count, unsigned int flags)
{
  mrb_int dstlen;
  unsigned long l;
  int column, srclen;
  char *srcptr, *dstptr, *dstptr0;

  srcptr = RSTRING_PTR(src);
  srclen = RSTRING_LEN(src);

  if (srclen == 0)  /* easy case */
    return 0;

  if (count != 0 && count < 3) {  /* -1, 1 or 2 */
    count = 45;
  } else if (count >= 3) {
    count -= count % 3;
  }

  dstlen = srclen / 3 * 4;
  if (count > 0) {
    dstlen += (srclen / count) + ((srclen % count) == 0 ? 0 : 1);
  }
  dst = str_len_ensure(mrb, dst, didx + dstlen);
  dstptr = RSTRING_PTR(dst) + didx;

  dstptr0 = dstptr;
  for (column = 3; srclen >= 3; srclen -= 3, column += 3) {
    l = (unsigned char)*srcptr++ << 16;
    l += (unsigned char)*srcptr++ << 8;
    l += (unsigned char)*srcptr++;

    *dstptr++ = base64chars[(l >> 18) & 0x3f];
    *dstptr++ = base64chars[(l >> 12) & 0x3f];
    *dstptr++ = base64chars[(l >>  6) & 0x3f];
    *dstptr++ = base64chars[ l        & 0x3f];

    if (column == count) {
      *dstptr++ = '\n';
      column = 0;
    }
  }
  if (srclen == 1) {
    l = (unsigned char)*srcptr++ << 16;
    *dstptr++ = base64chars[(l >> 18) & 0x3f];
    *dstptr++ = base64chars[(l >> 12) & 0x3f];
    *dstptr++ = '=';
    *dstptr++ = '=';
    column += 3;
  } else if (srclen == 2) {
    l = (unsigned char)*srcptr++ << 16;
    l += (unsigned char)*srcptr++ << 8;
    *dstptr++ = base64chars[(l >> 18) & 0x3f];
    *dstptr++ = base64chars[(l >> 12) & 0x3f];
    *dstptr++ = base64chars[(l >>  6) & 0x3f];
    *dstptr++ = '=';
    column += 3;
  }
  if (column > 0 && count > 0) {
    *dstptr++ = '\n';
  }

  return dstptr - dstptr0;
}

static int
unpack_m(mrb_state *mrb, const void *src, int slen, mrb_value ary, unsigned int flags)
{
  mrb_value dst;
  int dlen;
  unsigned long l;
  int i, padding;
  unsigned char c, ch[4];
  const char *sptr, *sptr0;
  char *dptr, *dptr0;

  sptr0 = sptr =(char *) src;

  dlen = slen / 4 * 3;  /* an estimated value - may be shorter */
  dst = mrb_str_new(mrb, NULL, dlen);
  dptr0 = dptr = RSTRING_PTR(dst);

  padding = 0;
  while (slen >= 4) {
    for (i = 0; i < 4; i++) {
      do {
        if (slen-- == 0)
          goto done;
        c = *sptr++;
  if (c >= sizeof(base64_dec_tab))
    continue;
  ch[i] = base64_dec_tab[c];
  if (ch[i] == PACK_BASE64_PADDING) {
    ch[i] = 0;
    padding++;
  }
      } while (ch[i] == PACK_BASE64_IGNORE);
    }

    l = (ch[0] << 18) + (ch[1] << 12) + (ch[2] << 6) + ch[3];

    if (padding == 0) {
      *dptr++ = (l >> 16) & 0xff;
      *dptr++ = (l >> 8) & 0xff;
      *dptr++ = l & 0xff;
    } else if (padding == 1) {
      *dptr++ = (l >> 16) & 0xff;
      *dptr++ = (l >> 8) & 0xff;
      break;
    } else {
      *dptr++ = (l >> 16) & 0xff;
      break;
    }
  }

done:
  dst = mrb_str_resize(mrb, dst, dptr - dptr0);
  mrb_ary_push(mrb, ary, dst);
  return sptr - sptr0;
}


static void
prepare_tmpl(mrb_state *mrb, struct tmpl *tmpl)
{
  mrb_get_args(mrb, "S", &tmpl->str);
  tmpl->idx = 0;
}

static int
has_tmpl(const struct tmpl *tmpl)
{
  return (tmpl->idx < RSTRING_LEN(tmpl->str));
}

static void
read_tmpl(mrb_state *mrb, struct tmpl *tmpl, int *dirp, int *typep, int *sizep, long *countp, unsigned int *flagsp)
{
  int ch, dir, t, tlen, type;
  int size = 0;
  long count = 1;
  unsigned int flags = 0;
  const char *tptr;

  tptr = RSTRING_PTR(tmpl->str);
  tlen = RSTRING_LEN(tmpl->str);

  t = tptr[tmpl->idx++];
alias:
  switch (t) {
  case 'A':
    dir = PACK_DIR_STR;
    type = PACK_TYPE_STRING;
    flags |= PACK_FLAG_WIDTH | PACK_FLAG_COUNT2;
    break;
  case 'a':
    dir = PACK_DIR_STR;
    type = PACK_TYPE_STRING;
    flags |= PACK_FLAG_WIDTH | PACK_FLAG_COUNT2 | PACK_FLAG_a;
    break;
  case 'C':
    dir = PACK_DIR_CHAR;
    type = PACK_TYPE_INTEGER;
    size = 1;
    break;
  case 'c':
    dir = PACK_DIR_CHAR;
    type = PACK_TYPE_INTEGER;
    size = 1;
    flags |= PACK_FLAG_SIGNED;
    break;
  case 'D': case 'd':
    dir = PACK_DIR_DOUBLE;
    type = PACK_TYPE_FLOAT;
    size = 8;
    flags |= PACK_FLAG_SIGNED;
    break;
  case 'F': case 'f':
    dir = PACK_DIR_FLOAT;
    type = PACK_TYPE_FLOAT;
    size = 4;
    flags |= PACK_FLAG_SIGNED;
    break;
  case 'E':
    dir = PACK_DIR_DOUBLE;
    type = PACK_TYPE_FLOAT;
    size = 8;
    flags |= PACK_FLAG_SIGNED | PACK_FLAG_LT;
    break;
  case 'e':
    dir = PACK_DIR_FLOAT;
    type = PACK_TYPE_FLOAT;
    size = 4;
    flags |= PACK_FLAG_SIGNED | PACK_FLAG_LT;
    break;
  case 'G':
    dir = PACK_DIR_DOUBLE;
    type = PACK_TYPE_FLOAT;
    size = 8;
    flags |= PACK_FLAG_SIGNED | PACK_FLAG_GT;
    break;
  case 'g':
    dir = PACK_DIR_FLOAT;
    type = PACK_TYPE_FLOAT;
    size = 4;
    flags |= PACK_FLAG_SIGNED | PACK_FLAG_GT;
    break;
  case 'H':
    dir = PACK_DIR_HEX;
    type = PACK_TYPE_STRING;
    flags |= PACK_FLAG_COUNT2;
    break;
  case 'h':
    dir = PACK_DIR_HEX;
    type = PACK_TYPE_STRING;
    flags |= PACK_FLAG_COUNT2 | PACK_FLAG_LSB;
    break;
  case 'I':
    switch (sizeof(int)) {
      case 2: t = 'S'; goto alias;
      case 4: t = 'L'; goto alias;
      case 8: t = 'Q'; goto alias;
      default:
        mrb_raisef(mrb, E_RUNTIME_ERROR, "mruby-pack does not support sizeof(int) == %S", mrb_fixnum_value(sizeof(int)));
    }
    break;
  case 'i':
    switch (sizeof(int)) {
      case 2: t = 's'; goto alias;
      case 4: t = 'l'; goto alias;
      case 8: t = 'q'; goto alias;
      default:
        mrb_raisef(mrb, E_RUNTIME_ERROR, "mruby-pack does not support sizeof(int) == %S", mrb_fixnum_value(sizeof(int)));
    }
    break;
  case 'L':
    dir = PACK_DIR_LONG;
    type = PACK_TYPE_INTEGER;
    size = 4;
    break;
  case 'l':
    dir = PACK_DIR_LONG;
    type = PACK_TYPE_INTEGER;
    size = 4;
    flags |= PACK_FLAG_SIGNED;
    break;
  case 'm':
    dir = PACK_DIR_BASE64;
    type = PACK_TYPE_STRING;
    flags |= PACK_FLAG_WIDTH;
    break;
  case 'N':  /* = "L>" */
    dir = PACK_DIR_LONG;
    type = PACK_TYPE_INTEGER;
    size = 4;
    flags |= PACK_FLAG_GT;
    break;
  case 'n':  /* = "S>" */
    dir = PACK_DIR_SHORT;
    type = PACK_TYPE_INTEGER;
    size = 2;
    flags |= PACK_FLAG_GT;
    break;
  case 'Q':
    dir = PACK_DIR_QUAD;
    type = PACK_TYPE_INTEGER;
    size = 8;
    break;
  case 'q':
    dir = PACK_DIR_QUAD;
    type = PACK_TYPE_INTEGER;
    size = 8;
    flags |= PACK_FLAG_SIGNED;
    break;
  case 'S':
    dir = PACK_DIR_SHORT;
    type = PACK_TYPE_INTEGER;
    size = 2;
    break;
  case 's':
    dir = PACK_DIR_SHORT;
    type = PACK_TYPE_INTEGER;
    size = 2;
    flags |= PACK_FLAG_SIGNED;
    break;
  case 'V':  /* = "L<" */
    dir = PACK_DIR_LONG;
    type = PACK_TYPE_INTEGER;
    size = 4;
    flags |= PACK_FLAG_LT;
    break;
  case 'v':  /* = "S<" */
    dir = PACK_DIR_SHORT;
    type = PACK_TYPE_INTEGER;
    size = 2;
    flags |= PACK_FLAG_LT;
    break;
  case 'Z':
    dir = PACK_DIR_STR;
    type = PACK_TYPE_STRING;
    flags |= PACK_FLAG_WIDTH | PACK_FLAG_COUNT2 | PACK_FLAG_Z;
    break;
  default:
    dir = PACK_DIR_INVALID;
    type = PACK_TYPE_NONE;
    break;
  }

  /* read suffix [0-9*_!<>] */
  while (tmpl->idx < tlen) {
    ch = tptr[tmpl->idx++];
    if (isdigit(ch)) {
      count = ch - '0';
      while (tmpl->idx < tlen && isdigit(tptr[tmpl->idx])) {
        count = count * 10 + (tptr[tmpl->idx++] - '0');
      }
      continue;  /* special case */
    } else if (ch == '*')  {
      count = -1;
    } else if (ch == '_' || ch == '!' || ch == '<' || ch == '>') {
      if (strchr("sSiIlLqQ", t) == NULL) {
        char ch_str = ch;
        mrb_raisef(mrb, E_ARGUMENT_ERROR, "'%S' allowed only after types sSiIlLqQ", mrb_str_new(mrb, &ch_str, 1));
      }
      if (ch == '_' || ch == '!') {
        flags |= PACK_FLAG_s;
      } else if (ch == '<') {
        flags |= PACK_FLAG_LT;
      } else if (ch == '>') {
        flags |= PACK_FLAG_GT;
      }
    } else {
      tmpl->idx--;
      break;
    }
  }

  if ((flags & PACK_FLAG_LT) || (!(flags & PACK_FLAG_GT) && littleendian)) {
    flags |= PACK_FLAG_LITTLEENDIAN;
  }

  *dirp = dir;
  *typep = type;
  *sizep = size;
  *countp = count;
  *flagsp = flags;
}

static mrb_value
mrb_pack_pack(mrb_state *mrb, mrb_value ary)
{
  mrb_value o, result;
  mrb_int aidx;
  struct tmpl tmpl;
  long count;
  unsigned int flags;
  int dir, ridx, size, type;

  prepare_tmpl(mrb, &tmpl);

  result = mrb_str_new(mrb, NULL, 128);  /* allocate initial buffer */
  aidx = 0;
  ridx = 0;
  while (has_tmpl(&tmpl)) {
    read_tmpl(mrb, &tmpl, &dir, &type, &size, &count, &flags);

    if (dir == PACK_DIR_INVALID)
      continue;

    for (; aidx < RARRAY_LEN(ary); aidx++) {
      if (count == 0 && !(flags & PACK_FLAG_WIDTH))
        break;

      o = mrb_ary_ref(mrb, ary, aidx);
      if (type == PACK_TYPE_INTEGER) {
        if (mrb_float_p(o)) {
          o = mrb_funcall(mrb, o, "to_i", 0);
        } else if (!mrb_fixnum_p(o)) {
          mrb_raisef(mrb, E_TYPE_ERROR, "can't convert %S into Integer", mrb_class_path(mrb, mrb_obj_class(mrb, o)));
        }
      } else if (type == PACK_TYPE_FLOAT) {
        if (!mrb_float_p(o)) {
          o = mrb_funcall(mrb, o, "to_f", 0);
        }
      } else if (type == PACK_TYPE_STRING) {
        if (!mrb_string_p(o)) {
          mrb_raisef(mrb, E_TYPE_ERROR, "can't convert %S into String", mrb_class_path(mrb, mrb_obj_class(mrb, o)));
        }
      }

      switch (dir) {
      case PACK_DIR_CHAR:
        ridx += pack_c(mrb, o, result, ridx, flags);
        break;
      case PACK_DIR_SHORT:
        ridx += pack_s(mrb, o, result, ridx, flags);
        break;
      case PACK_DIR_LONG:
        ridx += pack_l(mrb, o, result, ridx, flags);
        break;
      case PACK_DIR_QUAD:
        ridx += pack_q(mrb, o, result, ridx, flags);
        break;
      case PACK_DIR_BASE64:
        ridx += pack_m(mrb, o, result, ridx, count, flags);
        break;
      case PACK_DIR_HEX:
        ridx += pack_h(mrb, o, result, ridx, count, flags);
        break;
      case PACK_DIR_STR:
        ridx += pack_a(mrb, o, result, ridx, count, flags);
        break;
      case PACK_DIR_DOUBLE:
        ridx += pack_double(mrb, o, result, ridx, flags);
        break;
      case PACK_DIR_FLOAT:
        ridx += pack_float(mrb, o, result, ridx, flags);
        break;
      default:
        break;
      }
      if (dir == PACK_DIR_STR) { /* always consumes 1 entry */
        aidx++;
        break;
      }
      if (count > 0) {
        count--;
      }
    }
  }

  mrb_str_resize(mrb, result, ridx);
  return result;
}

static mrb_value
mrb_pack_unpack(mrb_state *mrb, mrb_value str)
{
  mrb_value result;
  struct tmpl tmpl;
  long count;
  unsigned int flags;
  int dir, size, srcidx, srclen, type;
  //const unsigned char *sptr;
  const unsigned char *sptr;


  prepare_tmpl(mrb, &tmpl);

  srcidx = 0;
  srclen = RSTRING_LEN(str);

  result = mrb_ary_new(mrb);
  while (has_tmpl(&tmpl)) {
    read_tmpl(mrb, &tmpl, &dir, &type, &size, &count, &flags);

    if (dir == PACK_DIR_INVALID)
      continue;

    if (flags & PACK_FLAG_COUNT2) {
      sptr = (unsigned char *)(RSTRING_PTR(str) + srcidx);
      switch (dir) {
      case PACK_DIR_HEX:
        srcidx += unpack_h(mrb, sptr, srclen - srcidx, result, count, flags);
        break;
      case PACK_DIR_STR:
        srcidx += unpack_a(mrb, sptr, srclen - srcidx, result, count, flags);
        break;
      }
      continue;
    }

    while (count != 0) {
      if (srclen - srcidx < size) {
        while (count-- > 0) {
          mrb_ary_push(mrb, result, mrb_nil_value());
        }
        break;
      }

      sptr =(unsigned char *)( RSTRING_PTR(str) + srcidx);
      switch (dir) {
      case PACK_DIR_CHAR:
        srcidx += unpack_c(mrb, sptr, srclen - srcidx, result, flags);
        break;
      case PACK_DIR_SHORT:
        srcidx += unpack_s(mrb, sptr, srclen - srcidx, result, flags);
        break;
      case PACK_DIR_LONG:
        srcidx += unpack_l(mrb, sptr, srclen - srcidx, result, flags);
        break;
      case PACK_DIR_QUAD:
        srcidx += unpack_q(mrb, sptr, srclen - srcidx, result, flags);
        break;
      case PACK_DIR_BASE64:
        srcidx += unpack_m(mrb, sptr, srclen - srcidx, result, flags);
        break;
      case PACK_DIR_FLOAT:
        srcidx += unpack_float(mrb, sptr, srclen - srcidx, result, flags);
        break;
      case PACK_DIR_DOUBLE:
        srcidx += unpack_double(mrb, sptr, srclen - srcidx, result, flags);
        break;
      }
      if (count > 0) {
        count--;
      }
    }
  }

  return result;
}


void register_cocos2dx_unzip_module(mrb_state* mrb)
{
    littleendian = check_little_endian();
    make_base64_dec_tab();
    mrb_define_method(mrb, mrb->array_class, "pack", mrb_pack_pack, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, mrb->string_class, "unpack", mrb_pack_unpack, MRB_ARGS_REQ(1));

    struct RClass* cc_module = mrb_module_get(mrb, "CC");
    struct RClass *zlib_module = mrb_define_module_under(mrb, cc_module, "Zlib");
    mrb_define_class_method(mrb, zlib_module, "deflate", ruby_cocos2dx_zlib_deflate_static, ARGS_REQ(1));
    mrb_define_class_method(mrb, zlib_module, "inflate", ruby_cocos2dx_zlib_inflate_static, ARGS_REQ(1));
    mrb_define_class_method(mrb, zlib_module, "unzip", ruby_cocos2dx_zlib_unzip_static, ARGS_REQ(2));
}