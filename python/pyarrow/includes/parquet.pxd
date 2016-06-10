# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# distutils: language = c++

from pyarrow.includes.common cimport *
from pyarrow.includes.libarrow cimport CSchema, CStatus, CTable, MemoryPool


cdef extern from "parquet/api/schema.h" namespace "parquet::schema" nogil:
  cdef cppclass Node:
    pass

  cdef cppclass GroupNode(Node):
    pass

  cdef cppclass PrimitiveNode(Node):
    pass

cdef extern from "parquet/api/schema.h" namespace "parquet" nogil:
  cdef cppclass SchemaDescriptor:
    shared_ptr[Node] schema()
    GroupNode* group()

  cdef cppclass ColumnDescriptor:
    pass

cdef extern from "parquet/api/reader.h" namespace "parquet" nogil:
    cdef cppclass ColumnReader:
        pass

    cdef cppclass BoolReader(ColumnReader):
        pass

    cdef cppclass Int32Reader(ColumnReader):
        pass

    cdef cppclass Int64Reader(ColumnReader):
        pass

    cdef cppclass Int96Reader(ColumnReader):
        pass

    cdef cppclass FloatReader(ColumnReader):
        pass

    cdef cppclass DoubleReader(ColumnReader):
        pass

    cdef cppclass ByteArrayReader(ColumnReader):
        pass

    cdef cppclass RowGroupReader:
        pass

    cdef cppclass ParquetFileReader:
        # TODO: Some default arguments are missing
        @staticmethod
        unique_ptr[ParquetFileReader] OpenFile(const c_string& path)

cdef extern from "parquet/api/writer.h" namespace "parquet" nogil:
    cdef cppclass OutputStream:
        pass

    cdef cppclass LocalFileOutputStream(OutputStream):
        LocalFileOutputStream(const c_string& path)
        void Close()


cdef extern from "arrow/parquet/reader.h" namespace "arrow::parquet" nogil:
    cdef cppclass FileReader:
        FileReader(MemoryPool* pool, unique_ptr[ParquetFileReader] reader)
        CStatus ReadFlatTable(shared_ptr[CTable]* out);


cdef extern from "arrow/parquet/schema.h" namespace "arrow::parquet" nogil:
    CStatus FromParquetSchema(const SchemaDescriptor* parquet_schema, shared_ptr[CSchema]* out)
    CStatus ToParquetSchema(const CSchema* arrow_schema, shared_ptr[SchemaDescriptor]* out)


cdef extern from "arrow/parquet/writer.h" namespace "arrow::parquet" nogil:
    cdef CStatus WriteFlatTable(const CTable* table, MemoryPool* pool, shared_ptr[OutputStream] sink, int64_t chunk_size)

