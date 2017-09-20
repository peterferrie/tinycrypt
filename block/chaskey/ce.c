/**
  Copyright © 2017 Odzhan. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. */
  
#include "chaskey.h"

void chaskey(void *key, void *buf) 
{
   int      i;
   uint32_t *v=(uint32_t*)buf;
   uint32_t *k=(uint32_t*)key;
   
   // pre-whiten
   for (i=0; i<4; i++) {
     v[i] ^= k[i];
   }

   // apply permutation function
   for (i=0; i<16; i++) {
     v[0] += v[1]; 
     v[1]=ROTL32(v[1], 5); 
     v[1] ^= v[0]; 
     v[0]=ROTL32(v[0],16);       
     v[2] += v[3]; 
     v[3]=ROTL32(v[3], 8); 
     v[3] ^= v[2];
     v[0] += v[3]; 
     v[3]=ROTL32(v[3],13); 
     v[3] ^= v[0];
     v[2] += v[1]; 
     v[1]=ROTL32(v[1], 7); 
     v[1] ^= v[2]; 
     v[2]=ROTL32(v[2],16);
   }
   // post-whiten
   for (i=0; i<4; i++) {
     v[i] ^= k[i];
   }
}
