; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.40219.01 

	TITLE	c:\hub\tinycrypt\hash\sha1\sha1.c
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	_SHA1_Transform
; Function compile flags: /Ogspy
; File c:\hub\tinycrypt\hash\sha1\sha1.c
;	COMDAT _SHA1_Transform
_TEXT	SEGMENT
_w$ = -340						; size = 320
_s$ = -20						; size = 20
_ctx$ = 8						; size = 4
_SHA1_Transform PROC					; COMDAT

; 38   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 340				; 00000154H
	push	esi

; 39   :     uint32_t t, i;
; 40   :     uint32_t w[80], s[SHA1_LBLOCK];
; 41   : 
; 42   :     // copy buffer to local
; 43   :     for (i=0; i<16; i++) {

	mov	esi, DWORD PTR _ctx$[ebp]
	push	ebx
	xor	edx, edx
	lea	ecx, DWORD PTR [esi+20]
	push	edi
$LL18@SHA1_Trans:

; 44   :       w[i] = SWAP32(ctx->buf.w[i]);

	mov	eax, DWORD PTR [ecx]
	mov	edi, eax
	ror	edi, 8
	and	edi, -16711936				; ff00ff00H
	rol	eax, 8
	and	eax, 16711935				; 00ff00ffH
	or	edi, eax
	mov	DWORD PTR _w$[ebp+edx*4], edi
	inc	edx
	add	ecx, 4
	cmp	edx, 16					; 00000010H
	jb	SHORT $LL18@SHA1_Trans

; 45   :     }
; 46   :     
; 47   :     // expand it
; 48   :     for (i=16; i<80; i++) {

	push	64					; 00000040H
	lea	eax, DWORD PTR _w$[ebp+8]
	pop	ecx
$LL15@SHA1_Trans:

; 49   :       w[i] = ROTL32(w[i -  3] ^ 
; 50   :                     w[i -  8] ^ 
; 51   :                     w[i - 14] ^ 
; 52   :                     w[i - 16], 1);

	mov	edx, DWORD PTR [eax+44]
	xor	edx, DWORD PTR [eax+24]
	xor	edx, DWORD PTR [eax-8]
	xor	edx, DWORD PTR [eax]
	add	eax, 4
	dec	ecx
	rol	edx, 1
	mov	DWORD PTR [eax+52], edx
	jne	SHORT $LL15@SHA1_Trans

; 53   :     }
; 54   :     
; 55   :     // load state
; 56   :     memcpy (s, ctx->s.b, SHA1_DIGEST_LENGTH);

	push	5
	pop	ecx
	lea	edi, DWORD PTR _s$[ebp]
	rep movsd

; 57   :     
; 58   :     // for 80 rounds
; 59   :     for (i=0; i<80; i++) {

	mov	ecx, DWORD PTR _s$[ebp+12]
	mov	edx, DWORD PTR _s$[ebp+8]
	mov	esi, DWORD PTR _s$[ebp+4]
	xor	edi, edi
$LL12@SHA1_Trans:

; 60   :       if (i<20) {
; 61   :         t = (s[3] ^ (s[1] & (s[2] ^ s[3]))) + 0x5A827999L;

	mov	eax, edx
	cmp	edi, 20					; 00000014H
	jae	SHORT $LN9@SHA1_Trans
	xor	eax, ecx
	and	eax, esi
	xor	eax, ecx
	add	eax, 1518500249				; 5a827999H
	jmp	SHORT $LN4@SHA1_Trans
$LN9@SHA1_Trans:

; 62   :       } else if (i<40) {

	cmp	edi, 40					; 00000028H
	jae	SHORT $LN7@SHA1_Trans

; 63   :         t = (s[1] ^ s[2] ^ s[3]) + 0x6ED9EBA1L;

	xor	eax, esi
	xor	eax, ecx
	add	eax, 1859775393				; 6ed9eba1H
	jmp	SHORT $LN4@SHA1_Trans
$LN7@SHA1_Trans:

; 64   :       } else if (i<60) {

	cmp	edi, 60					; 0000003cH
	jae	SHORT $LN5@SHA1_Trans

; 65   :         t = ((s[1] & s[2]) | (s[3] & (s[1] | s[2]))) + 0x8F1BBCDCL;

	or	eax, esi
	mov	ebx, edx
	and	eax, ecx
	and	ebx, esi
	or	eax, ebx
	sub	eax, 1894007588				; 70e44324H

; 66   :       } else {

	jmp	SHORT $LN4@SHA1_Trans
$LN5@SHA1_Trans:

; 67   :         t = (s[1] ^ s[2] ^ s[3]) + 0xCA62C1D6L;

	xor	eax, esi
	xor	eax, ecx
	sub	eax, 899497514				; 359d3e2aH
$LN4@SHA1_Trans:

; 68   :       }
; 69   :       t += ROTL32(s[0], 5) + s[4] + w[i];

	mov	ebx, DWORD PTR _s$[ebp]
	rol	ebx, 5
	add	ebx, DWORD PTR _w$[ebp+edi*4]
	add	ebx, DWORD PTR _s$[ebp+16]

; 70   :       s[4] = s[3];

	mov	DWORD PTR _s$[ebp+16], ecx
	add	eax, ebx

; 71   :       s[3] = s[2];
; 72   :       s[2] = ROTL32(s[1], 30);

	ror	esi, 2
	mov	ecx, edx
	inc	edi
	mov	edx, esi

; 73   :       s[1] = s[0];

	mov	esi, DWORD PTR _s$[ebp]

; 74   :       s[0] = t;

	mov	DWORD PTR _s$[ebp], eax
	cmp	edi, 80					; 00000050H
	jb	SHORT $LL12@SHA1_Trans

; 75   :     }
; 76   :     
; 77   :     // update state
; 78   :     for (i=0; i<SHA1_LBLOCK; i++) {

	mov	eax, DWORD PTR _ctx$[ebp]
	push	5
	mov	DWORD PTR _s$[ebp+8], edx
	pop	edx
	mov	DWORD PTR _s$[ebp+12], ecx
	lea	ecx, DWORD PTR _s$[ebp]
	pop	edi
	mov	DWORD PTR _s$[ebp+4], esi
	sub	ecx, eax
	pop	ebx
$LL3@SHA1_Trans:

; 79   :       ctx->s.w[i] += s[i];

	mov	esi, DWORD PTR [ecx+eax]
	add	DWORD PTR [eax], esi
	add	eax, 4
	dec	edx
	jne	SHORT $LL3@SHA1_Trans
	pop	esi

; 80   :     }
; 81   : }

	leave
	ret	0
_SHA1_Transform ENDP
_TEXT	ENDS
PUBLIC	_SHA1_Init
; Function compile flags: /Ogspy
;	COMDAT _SHA1_Init
_TEXT	SEGMENT
_c$ = 8							; size = 4
_SHA1_Init PROC						; COMDAT

; 89   :     c->len    = 0;

	mov	eax, DWORD PTR _c$[esp-4]
	and	DWORD PTR [eax+84], 0
	and	DWORD PTR [eax+88], 0

; 90   :     c->s.w[0] = 0x67452301;

	mov	DWORD PTR [eax], 1732584193		; 67452301H

; 91   :     c->s.w[1] = 0xefcdab89;

	mov	DWORD PTR [eax+4], -271733879		; efcdab89H

; 92   :     c->s.w[2] = 0x98badcfe;

	mov	DWORD PTR [eax+8], -1732584194		; 98badcfeH

; 93   :     c->s.w[3] = 0x10325476;

	mov	DWORD PTR [eax+12], 271733878		; 10325476H

; 94   :     c->s.w[4] = 0xc3d2e1f0;

	mov	DWORD PTR [eax+16], -1009589776		; c3d2e1f0H

; 95   : }

	ret	0
_SHA1_Init ENDP
_TEXT	ENDS
PUBLIC	_SHA1_Update
EXTRN	_memcpy:PROC
; Function compile flags: /Ogspy
;	COMDAT _SHA1_Update
_TEXT	SEGMENT
_c$ = 8							; size = 4
_p$ = 12						; size = 4
_in$ = 12						; size = 4
_len$ = 16						; size = 4
_SHA1_Update PROC					; COMDAT

; 102  : void SHA1_Update (SHA1_CTX *c, void *in, uint32_t len) {

	push	ebp
	mov	ebp, esp

; 103  :     uint8_t *p = (uint8_t*)in;

	mov	eax, DWORD PTR _in$[ebp]
	mov	DWORD PTR _p$[ebp], eax

; 104  :     uint32_t  r, idx;
; 105  :     
; 106  :     if (len==0) return;

	mov	eax, DWORD PTR _len$[ebp]
	test	eax, eax
	je	SHORT $LN10@SHA1_Updat

; 107  :     
; 108  :     // get buffer index
; 109  :     idx = c->len & (SHA1_CBLOCK - 1);

	push	esi
	mov	esi, DWORD PTR _c$[ebp]
	push	edi
	mov	edi, DWORD PTR [esi+84]
	and	edi, 63					; 0000003fH

; 110  :     
; 111  :     // update length
; 112  :     c->len += len;

	add	DWORD PTR [esi+84], eax
	adc	DWORD PTR [esi+88], 0

; 113  :     
; 114  :     while (len > 0) {

	test	eax, eax
	je	SHORT $LN13@SHA1_Updat
	push	ebx
	jmp	SHORT $LN3@SHA1_Updat
$LL12@SHA1_Updat:
	mov	eax, DWORD PTR _len$[ebp]
$LN3@SHA1_Updat:

; 115  :       r = MIN(len, SHA1_CBLOCK - idx);

	push	64					; 00000040H
	pop	ebx
	sub	ebx, edi
	cmp	eax, ebx
	jae	SHORT $LN7@SHA1_Updat
	mov	ebx, eax
$LN7@SHA1_Updat:

; 116  :       memcpy ((void*)&c->buf.b[idx], p, r);

	push	ebx
	push	DWORD PTR _p$[ebp]
	lea	eax, DWORD PTR [esi+edi+20]
	push	eax
	call	_memcpy

; 117  :       if ((idx + r) < SHA1_CBLOCK) break;

	lea	eax, DWORD PTR [ebx+edi]
	add	esp, 12					; 0000000cH
	cmp	eax, 64					; 00000040H
	jb	SHORT $LN15@SHA1_Updat

; 118  :       
; 119  :       SHA1_Transform (c);

	push	esi
	call	_SHA1_Transform

; 120  :       len -= r;

	sub	DWORD PTR _len$[ebp], ebx

; 121  :       idx = 0;
; 122  :       p += r;

	add	DWORD PTR _p$[ebp], ebx
	xor	edi, edi
	pop	ecx
	cmp	DWORD PTR _len$[ebp], edi
	ja	SHORT $LL12@SHA1_Updat
$LN15@SHA1_Updat:
	pop	ebx
$LN13@SHA1_Updat:
	pop	edi
	pop	esi
$LN10@SHA1_Updat:

; 123  :     }
; 124  : }

	pop	ebp
	ret	0
_SHA1_Update ENDP
_TEXT	ENDS
PUBLIC	_SHA1_Final
EXTRN	_memset:PROC
; Function compile flags: /Ogspy
;	COMDAT _SHA1_Final
_TEXT	SEGMENT
_dgst$ = 8						; size = 4
_c$ = 12						; size = 4
_SHA1_Final PROC					; COMDAT

; 132  : {

	push	ebx
	push	esi

; 133  :     uint32_t i;
; 134  :     
; 135  :     // see what length we have ere..
; 136  :     uint32_t len=c->len & (SHA1_CBLOCK - 1);

	mov	esi, DWORD PTR _c$[esp+4]
	push	edi
	mov	edi, DWORD PTR [esi+84]

; 137  : 
; 138  :     // fill remaining space with zeros
; 139  :     memset (&c->buf.b[len], 0, SHA1_CBLOCK - len);

	push	64					; 00000040H
	pop	eax
	and	edi, 63					; 0000003fH
	sub	eax, edi
	push	eax
	lea	ebx, DWORD PTR [edi+esi+20]
	push	0
	push	ebx
	call	_memset
	add	esp, 12					; 0000000cH

; 140  :     
; 141  :     // add the end bit
; 142  :     c->buf.b[len] = 0x80;

	mov	BYTE PTR [ebx], 128			; 00000080H

; 143  :     
; 144  :     // if exceeding 56 bytes, transform it
; 145  :     if (len >= 56) {

	cmp	edi, 56					; 00000038H
	jb	SHORT $LN4@SHA1_Final

; 146  :       SHA1_Transform (c);

	push	esi
	call	_SHA1_Transform

; 147  :       // clear buffer
; 148  :       memset (c->buf.b, 0, SHA1_CBLOCK);

	push	64					; 00000040H
	lea	eax, DWORD PTR [esi+20]
	push	0
	push	eax
	call	_memset
	add	esp, 16					; 00000010H
$LN4@SHA1_Final:

; 149  :     }
; 150  :     // add total bits
; 151  :     c->buf.q[7] = SWAP64(c->len * 8);

	mov	eax, DWORD PTR [esi+84]
	mov	ecx, DWORD PTR [esi+88]
	shld	ecx, eax, 3
	shl	eax, 3
	mov	edx, eax
	ror	edx, 8
	mov	ebx, -16711936				; ff00ff00H
	and	edx, ebx
	rol	eax, 8
	push	ebp
	mov	edi, 16711935				; 00ff00ffH
	and	eax, edi
	or	edx, eax
	mov	ebp, ecx
	xor	eax, eax
	ror	ebp, 8
	and	ebp, ebx
	rol	ecx, 8
	and	ecx, edi
	or	ebp, ecx
	xor	ecx, ecx
	or	eax, ebp
	or	edx, ecx

; 152  :     
; 153  :     // compress
; 154  :     SHA1_Transform (c);

	push	esi
	mov	DWORD PTR [esi+76], eax
	mov	DWORD PTR [esi+80], edx
	call	_SHA1_Transform
	pop	ecx

; 155  :     
; 156  :     // swap byte order
; 157  :     for (i=0; i<SHA1_LBLOCK; i++) {

	xor	ecx, ecx
	pop	ebp
$LL3@SHA1_Final:

; 158  :       c->s.w[i] = SWAP32(c->s.w[i]);

	mov	eax, DWORD PTR [esi+ecx*4]
	mov	edx, eax
	ror	edx, 8
	and	edx, ebx
	rol	eax, 8
	and	eax, edi
	or	edx, eax
	mov	DWORD PTR [esi+ecx*4], edx
	inc	ecx
	cmp	ecx, 5
	jb	SHORT $LL3@SHA1_Final

; 159  :     }
; 160  :     // copy digest to buffer
; 161  :     memcpy (dgst, c->s.b, SHA1_DIGEST_LENGTH);

	mov	edi, DWORD PTR _dgst$[esp+8]
	push	5
	pop	ecx
	rep movsd
	pop	edi
	pop	esi
	pop	ebx

; 162  : }

	ret	0
_SHA1_Final ENDP
_TEXT	ENDS
END
