#ifdef HAVE_CONFIG_H
# include "config.h"
#endif /* HAVE_CONFIG_H */

#include "Evil.h"
#include "evil_private.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#undef rename
#undef getline
#undef getdelim

int 
evil_rename(const char *src, const char* dst)
{
   struct stat st;

   if (stat(dst, &st) < 0)
        return rename(src, dst);

   if (stat(src, &st) < 0)
        return -1;

   if (S_ISDIR(st.st_mode))
     {
        rmdir(dst);
        return rename(src, dst);
     }

   if (S_ISREG(st.st_mode))
     {
        unlink(dst);
        return rename(src, dst);
     }

   return -1;
}

ssize_t
evil_getline (char **lineptr, size_t *n, FILE *stream)
{
  return evil_getdelim (lineptr, n, '\n', stream);
}

/* Default value for line length.  */
static const int line_size = 128;

ssize_t
evil_getdelim (char **lineptr, size_t *n, int delim, FILE *stream)
{
  int indx = 0;
  int c;

  /* Sanity checks.  */
  if (lineptr == NULL || n == NULL || stream == NULL)
    return -1;

  /* Allocate the line the first time.  */
  if (*lineptr == NULL)
    {
      *lineptr = malloc (line_size);
      if (*lineptr == NULL)
       return -1;
      *n = line_size;
    }

  while ((c = getc (stream)) != EOF)
    {
      /* Check if more memory is needed.  */
      if (indx >= *n)
       {
         *lineptr = realloc (*lineptr, *n + line_size);
         if (*lineptr == NULL)
           return -1;
         *n += line_size;
       }

      /* Push the result in the line.  */
      (*lineptr)[indx++] = c;

      /* Bail out.  */
      if (c == delim)
       break;
    }

  /* Make room for the null character.  */
  if (indx >= *n)
    {
      *lineptr = realloc (*lineptr, *n + line_size);
      if (*lineptr == NULL)
       return -1;
      *n += line_size;
    }

  /* Null terminate the buffer.  */
  (*lineptr)[indx++] = 0;

  /* The last line may not have the delimiter, we have to
   * return what we got and the error will be seen on the
   * next iteration.  */
  return (c == EOF && (indx - 1) == 0) ? -1 : indx - 1;
}

