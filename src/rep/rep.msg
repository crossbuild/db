/*-
 * See the file LICENSE for redistribution information.
 *
 * Copyright (c) 2001, 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * $Id$
 */

DBPRIVATE
PREFIX  __rep

INCLUDE #include "db_int.h"
INCLUDE #include "dbinc/db_page.h"
INCLUDE #include "dbinc/db_am.h"
INCLUDE #include "dbinc/mp.h"
INCLUDE #include "dbinc/txn.h"
INCLUDE

/*
 * bulk - message for bulk log records or pages
 */
BEGIN_MSG bulk		check_length
ARG	len		u_int32_t
ARG	lsn		DB_LSN
ARG	bulkdata	DBT
END

/*
 * control - replication control message
 */
BEGIN_MSG control	check_length
ARG	rep_version	u_int32_t
ARG	log_version	u_int32_t
ARG	lsn		DB_LSN
ARG	rectype		u_int32_t
ARG	gen		u_int32_t
ARG	msg_sec		u_int32_t
ARG	msg_nsec	u_int32_t
ARG	flags		u_int32_t
END

/*
 * egen data
 */
BEGIN_MSG egen		check_length
ARG	egen		u_int32_t
END

/*
 * file info
 *
 * NOTE:  The order of the DBTs is important and relevant in the
 * GET_CURINFO macro.
 */
BEGIN_MSG fileinfo	alloc check_length version
ARG	pgsize		u_int32_t
ARG	pgno		db_pgno_t
ARG	max_pgno	db_pgno_t
ARG	filenum		u_int32_t
ARG	finfo_flags	u_int32_t
ARG	type		u_int32_t
ARG	db_flags	u_int32_t
ARG	uid		DBT
ARG	info		DBT
ARG	dir		DBT
ARG	blob_fid_lo	u_int32_t
ARG	blob_fid_hi	u_int32_t
END

BEGIN_MSG fileinfo_v7	alloc check_length version
ARG	pgsize		u_int32_t
ARG	pgno		db_pgno_t
ARG	max_pgno	db_pgno_t
ARG	filenum		u_int32_t
ARG	finfo_flags	u_int32_t
ARG	type		u_int32_t
ARG	db_flags	u_int32_t
ARG	uid		DBT
ARG	info		DBT
ARG	dir		DBT
END

BEGIN_MSG fileinfo_v6	alloc check_length version
ARG	pgsize		u_int32_t
ARG	pgno		db_pgno_t
ARG	max_pgno	db_pgno_t
ARG	filenum		u_int32_t
ARG	finfo_flags	u_int32_t		
ARG	type		u_int32_t
ARG	db_flags	u_int32_t
ARG	uid		DBT
ARG	info		DBT
END

/*
 * grant info - clients send to masters granting a lease.
 */
BEGIN_MSG grant_info	check_length
ARG	msg_sec		u_int32_t
ARG	msg_nsec	u_int32_t
END

/*
 * We do not need to do anything with LOG record data.
 * It is opaque data to us.
 */

/*
 * log request
 */
BEGIN_MSG logreq	check_length
ARG	endlsn		DB_LSN
END

/*
 * We do not need to do anything with NEWCLIENT/NEWSITE cdata dbt.
 * It is user data and the app has to do whatever transformation
 * it needs to with its own data.
 */
/*
 * newfile version
 */
BEGIN_MSG newfile	check_length
ARG	version		u_int32_t
END

/*
 * update - send update information
 */
BEGIN_MSG update	alloc check_length version
ARG	first_lsn	DB_LSN
ARG	first_vers	u_int32_t
ARG	num_files	u_int32_t
END

/*
 * vote info.  Current version.
 */
BEGIN_MSG vote_info	check_length
ARG	egen		u_int32_t
ARG	nsites		u_int32_t
ARG	nvotes		u_int32_t
ARG	priority	u_int32_t
ARG	spare_pri	u_int32_t
ARG	tiebreaker	u_int32_t
ARG	data_gen	u_int32_t
END
/*
 * vote info old version from REPVERSION 5 and earlier.
 */
BEGIN_MSG vote_info_v5	check_length
ARG	egen		u_int32_t
ARG	nsites		u_int32_t
ARG	nvotes		u_int32_t
ARG	priority	u_int32_t
ARG	tiebreaker	u_int32_t
END

/*
 * LSN history database - key
 */ 
BEGIN_MSG lsn_hist_key
ARG	version		u_int32_t
ARG	gen		u_int32_t
END

/*
 * LSN history database - data
 */ 
BEGIN_MSG lsn_hist_data
ARG	envid		u_int32_t
ARG	lsn		DB_LSN
ARG	hist_sec	u_int32_t
ARG	hist_nsec	u_int32_t
END

/*
 * Request for blob files.
 */
BEGIN_MSG blob_update_req
ARG	blob_fid	u_int64_t
ARG	blob_sid	u_int64_t
ARG	blob_id		u_int64_t
ARG	highest_id	u_int64_t
END

/*
 * A list of blob file for a database.
 */
BEGIN_MSG blob_update
ARG	blob_fid	u_int64_t
ARG	highest_id	u_int64_t
ARG	flags		u_int32_t
ARG	num_blobs	u_int32_t
END

/*
 * Blob file description, part of blob_update.
 */
BEGIN_MSG blob_file
ARG	blob_sid	u_int64_t
ARG	blob_id		u_int64_t
ARG	blob_size	u_int64_t
END

/*
 * A piece of data from a blob file.
 */
BEGIN_MSG blob_chunk
ARG	flags		u_int32_t
ARG	blob_fid	u_int64_t
ARG	blob_sid	u_int64_t
ARG	blob_id		u_int64_t
ARG	offset		u_int64_t
ARG	data		DBT
END

/*
 * Request for data from a blob file at the given offset.
 */
BEGIN_MSG blob_chunk_req
ARG	blob_fid	u_int64_t
ARG	blob_sid	u_int64_t
ARG	blob_id		u_int64_t
ARG	offset		u_int64_t
END	
