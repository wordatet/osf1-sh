/* 
 * *****************************************************************
 * *                                                               *
 * *    Copyright (c) Digital Equipment Corporation, 1991, 1994    *
 * *                                                               *
 * *   All Rights Reserved.  Unpublished rights  reserved  under   *
 * *   the copyright laws of the United States.                    *
 * *                                                               *
 * *   The software contained on this media  is  proprietary  to   *
 * *   and  embodies  the  confidential  technology  of  Digital   *
 * *   Equipment Corporation.  Possession, use,  duplication  or   *
 * *   dissemination of the software and media is authorized only  *
 * *   pursuant to a valid written license from Digital Equipment  *
 * *   Corporation.                                                *
 * *                                                               *
 * *   RESTRICTED RIGHTS LEGEND   Use, duplication, or disclosure  *
 * *   by the U.S. Government is subject to restrictions  as  set  *
 * *   forth in Subparagraph (c)(1)(ii)  of  DFARS  252.227-7013,  *
 * *   or  in  FAR 52.227-19, as applicable.                       *
 * *                                                               *
 * *****************************************************************
 */
/*
 * (c) Copyright 1990, 1991, 1992, 1993 OPEN SOFTWARE FOUNDATION, INC.
 * ALL RIGHTS RESERVED
 */
#if !defined(lint) && !defined(_NOIDENT)
static char rcsid[] = "@(#)$RCSfile: stak.c,v $ $Revision: 4.2.5.4 $ (DEC) $Date: 1993/11/10 23:54:28 $";
#endif
/*
 * HISTORY
 */
/*
 * OSF/1 1.2
 */
/*
 * COMPONENT_NAME: (CMDSH) Bourne shell and related commands
 *
 * FUNCTIONS:
 *
 *
 * (C) COPYRIGHT International Business Machines Corp. 1989
 * All Rights Reserved
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 * Copyright (c) 1980 Regents of the University of California.
 * All rights reserved.  The Berkeley software License Agreement
 * specifies the terms and conditions for redistribution.
 *
 * Copyright 1976, Bell Telephone Laboratories, Inc.
 *
 *	1.11  com/cmd/sh/sh/stak.c, 9121320k, bos320 12/6/90 09:35:02
 */

#include	"defs.h"
#include	<sys/access.h>
#include	<sys/param.h>
#include <sys/types.h>
#include <sys/mman.h>
/* #define BRKMAX 2*8192 */

/* ========	storage allocation	======== */

uchar_t *
getstak(asize)			/* allocate requested stack */
int	asize;
{
	register uchar_t	*oldstak;
	register ptrdiff_t	size;

	locstak();	/* make sure stack is big enough */
	size = round(asize, BYTESPERWORD);
	oldstak = stakbot;
	staktop = stakbot += size;
	needmem (stakbot + BRKINCR);
	return(oldstak);
}

/*
 * set up stack for local use
 * should be followed by `endstak'
 */
uchar_t *
locstak()
{
	/*
	 * In shared case we must have enough for any possible 
	 * glob since malloc is the standard library version 
	 * - so get BRKMAX always. N.B. this must be larger 
	 * than the (NLS) max path name and the CPYSTR in io.c
	 */
	if (brkend - stakbot < BRKMAX)
		if (growstak())
			error(MSGSTR(M_NOSPACE,(char *) nospace));
	needmem (stakbot + BRKINCR);
	return(stakbot);
}

uchar_t *
savstak()
{
	assert(staktop == stakbot);
	return(stakbot);
}

uchar_t *
endstak(argp)		/* tidy up after `locstak' */
register uchar_t	*argp;
{
	register uchar_t	*oldstak;

	*argp++ = 0;
	oldstak = stakbot;
	stakbot = staktop = (uchar_t *)round(argp, BYTESPERWORD);
	return(oldstak);
}

void
tdystak(x)              /* try to bring stack back to x */
uchar_t *x;
{
	while (stakbsy > (struct blk *)(x))
		popstak();
	rmtemp(x);
}

void
popstak()
{
	register struct blk *p;

	if (p = stakbsy)
	{
		stakbsy = p->word;
		alloc_free(p);
	}
}

void
stakchk()
{
	/* No-op for now in portable version */
}

uchar_t *
cpystak(x)
uchar_t	*x;
{
	register uchar_t    *argp = locstak ();
	assert(argp+strlen((char *)x)+2 < brkend);
	locstak();	/* make sure its big enough */
	return (endstak(movstr(x,argp)));
}

int
growstak()
{
	if (stakbot == 0)
	{
		unsigned int size = BRKMAX + BRKMAX;
		stakbot = (uchar_t *) malloc(size);
		if (stakbot == NULL)
			return -1;
		brkend = stakbot + size;
		stakbas = staktop = stakbot;
		return 0;
	}

	/* 
	 * In a truly portable version, we might want to realloc,
	 * but that invalidates pointers. For now, we'll try to malloc
	 * a new larger block and copy, but we must be aware of pointer stability.
	 * Better yet, for historical UNIX sh, just allocate a very large block initially.
	 */
	unsigned int current_size = (Rcheat(brkend) - Rcheat(stakbas));
	unsigned int new_size = current_size + BRKMAX;
	uchar_t *new_stak = (uchar_t *) realloc(stakbas, new_size);
	
	if (new_stak == NULL)
		return -1;

	/* Update pointers if move occurred (DANGEROUS if external pointers exist) */
	if (new_stak != stakbas) {
		ptrdiff_t offset = new_stak - stakbas;
		stakbot += offset;
		staktop += offset;
		stakbas = new_stak;
	}
	brkend = stakbas + new_size;
	return 0;
}
