#ifndef AIENGINE_HELPER_H_
#define AIENGINE_HELPER_H_

#ifdef __cplusplus
extern "C" {
#endif

const char * aiengine_helper_register_device_once(const char *app_key, const char *secret_key, const char *device_id, const char *user_id);

#ifdef __cplusplus
}
#endif

#endif
