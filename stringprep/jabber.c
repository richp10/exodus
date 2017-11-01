/* #include "config.h" */
#include "stringprep.h"

/**
#define stringprep_xmpp_nodeprep(in, maxlen)		\
  stringprep(in, maxlen, 0, stringprep_xmpp_nodeprep)
#define stringprep_xmpp_resourceprep(in, maxlen)		\
  stringprep(in, maxlen, 0, stringprep_xmpp_resourceprep)
**/

int jabber_nodeprep(const char* input, char* buff, size_t buf_sz)
{
    // copy the input into the buffer
    strncpy(buff, input, buf_sz);

    // stringprep, dup, and return
    if (stringprep_xmpp_nodeprep(buff, buf_sz) == STRINGPREP_OK) 
    {
        return 0;
    }
    else
    {
        return -1;
    }
}

int jabber_nameprep(const char* input, char* buff, size_t buf_sz)
{
    // copy the input into the buffer
    strncpy(buff, input, buf_sz);

    // stringprep, dup, and return
    if (stringprep_nameprep(buff, buf_sz) == STRINGPREP_OK)
    {      
        return 0;
    }
    else
    {
        return -1;
    }
}

int jabber_resourceprep(const char* input, char* buff, size_t buf_sz)
{
    // copy the input into the buffer
    strncpy(buff, input, buf_sz);

    // stringprep, dup, and return
    if (stringprep_xmpp_resourceprep(buff, buf_sz) == STRINGPREP_OK)
    {
        return 0;
    }
    else
    {
        return -1;
    }
}
