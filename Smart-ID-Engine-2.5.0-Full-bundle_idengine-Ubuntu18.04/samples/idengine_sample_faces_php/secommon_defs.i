//  Copyright (c) 2016-2024, Smart Engines Service LLC
//  All rights reserved.

%include std_map.i
%include std_string.i
%include std_vector.i
%include stdint.i
%include typemaps.i
%include exception.i
%include std_except.i



%apply (char *STRING, size_t LENGTH) {(unsigned char* raw_data, int raw_data_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* config_data, int config_data_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* yuv_data, int yuv_data_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* data, int data_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* buffer, int buffer_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* y_plane, int y_plane_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* u_plane, int u_plane_length)};
%apply (char *STRING, size_t LENGTH) {(unsigned char* v_plane, int v_plane_length)};
%apply (char *STRING, size_t LENGTH) {(const unsigned char *bytes, size_t n)};
%apply (char *STRING, size_t LENGTH) {(const char* out_buffer, int buffer_length)};

%apply unsigned char INPUT[] { unsigned char* bytes };


%include "secommon/se_export_defs.h"
