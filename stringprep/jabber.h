/** 
 * Header file for libidn.dll for jabber specific applications
 **/

/**
 The input buffer contains the UTF8 encoded string to be 
 canonicalized. The caller MUST allocate a buffer and pass a 
 pointer to that buffer into the various functions. This buffer
 will be used as the output buffer for the canonicalized string.
 Specify the buffer size in the buf_sz parameters.

 All functions return 0 on success, -1 on failure.

 The caller is resposible for allocating and freeing the 
 output buffer. Jabber ID components (node, domain, resource)
 have a maximum size of 1k, so that is the recommended output buffer
 size.
**/

int jabber_nodeprep(const char* input, char* buf, size_t buf_sz);
int jabber_nameprep(const char* input, char* buf, size_t buf_sz);
int jabber_resourceprep(const char* input, char* buf, size_t buf_sz);
