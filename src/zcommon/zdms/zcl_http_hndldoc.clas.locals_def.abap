CONSTANTS: UploadURL   TYPE string VALUE 'DMS-UPLOAD-URL',
           DownloadURL TYPE string VALUE 'DMS-DOWNLOAD-URL',
           DeleteURL   TYPE string VALUE 'DMS-DELETE-URL',
           headerName  TYPE string VALUE 'x-functions-key',
           headerValue TYPE string VALUE 'DMS-FUNCTION-KEY',
           container   TYPE string VALUE 'DMS-CONTAINER'.


TYPES: BEGIN OF ty_request,
         FileName      TYPE string,
         FileSize      TYPE i,
         FileType      TYPE string,
         FileContent   TYPE xstring,
         DocType       TYPE string,
         description   TYPE string,
         category      TYPE string,
         DocLink       TYPE string,
         RefObjectType TYPE string,
         RefObjectKey  TYPE string,
       END OF ty_request.

TYPES :BEGIN OF ty_get_request,
         docuuid   TYPE string,
         action    TYPE string,
       END OF ty_get_request.

TYPES: BEGIN OF ty_upload_res,
         isSuccess TYPE string,
         message   TYPE string,
         data      TYPE string,
       END OF ty_upload_res.

TYPES: BEGIN OF ty_error_res,
         error TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
       END OF ty_error_res.
