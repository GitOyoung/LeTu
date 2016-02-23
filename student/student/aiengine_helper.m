#include "aiengine_helper.h"
#include <stdio.h>
#include <time.h>

#import <Foundation/NSBundle.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

static const char *
_sha1(const char *message)
{
    static char sha1[64];
    unsigned char md[20];
    CC_SHA1(message, (CC_LONG)strlen(message), md);

    sprintf(sha1, "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            md[0], md[1], md[2], md[3], md[4], md[5], md[6], md[7], md[8], md[9],
            md[10], md[11], md[12], md[13], md[14], md[15], md[16], md[17], md[18], md[19]);

    return sha1;
}


static const char *
_read_file(const char *path)
{
    static char line[128];

    int rv = -1;
    FILE *file = NULL;
    file = fopen(path, "r");
    if (!file) {
        goto end;
    }

    memset(line, 0, sizeof(line));
    rv = !(int)fread(line, 1, sizeof(line) - 1, file);
    fclose(file);

end:
    if (file) {
        fclose(file);
    }

    return !rv ? line : NULL;
}


static int
_write_file(const char *path, const char *str)
{
    int rv = -1;
    FILE *file = NULL;
    file = fopen(path, "w");
    if (!file) {
        goto end;
    }

    rv = !(int)fwrite(str, 1, strlen(str), file);
    fclose(file);

end:
    if (file) {
        fclose(file);
    }
    return rv;
}

const char *
aiengine_helper_register_device_once(const char *app_key, const char *secret_key, const char *device_id, const char *user_id)
{
    static char serial_number[64];

    int rv = -1;
    const char *sig, *existed_serial_number;
    char msg[1024];
    long timestamp;

    NSString *serial_path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/aiengine.serial"];

    existed_serial_number = _read_file([serial_path UTF8String]);
    if (existed_serial_number) {
        strcpy(serial_number, existed_serial_number);
        rv = 0;
        //goto end;   /* already registered */
        printf("serial number: %s\n", !rv ? serial_number : "");
        return !rv ? serial_number : NULL;
    }

    timestamp = (long)time(NULL);

    sprintf(msg, "%s%ld%s%s", app_key, timestamp, secret_key, device_id);
    sig = _sha1(msg);

    NSData *content = [[NSString stringWithFormat:@"appKey=%s&timestamp=%ld&deviceId=%s&sig=%s&userId=%s", app_key, timestamp, device_id, sig, user_id] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *length = [NSString stringWithFormat:@"%d",(int)[content length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://auth.api.chivox.com/device"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:content];


    NSHTTPURLResponse *response = NULL;
    NSError *error = NULL;

    content = [NSURLConnection
                  sendSynchronousRequest:request
                  returningResponse:&response
                  error:&error];

    if (content && response && response.statusCode == 200) {
        const char *json = [[[NSString alloc] initWithData:content encoding: NSUTF8StringEncoding] UTF8String];
        if (json[0] == '{' && json[strlen(json) - 1] == '}') {
            char *p, *q;
            p = strstr(json, "\"serialNumber\":");
            printf("auth service response: %s\n", json);
            if (p) {
                p = strchr(p + strlen("\"serialNumber\":"), '"') + 1;
                q = strchr(p, '"') - 1;
                strncpy(serial_number, p, q - p + 1);
                _write_file([serial_path UTF8String], serial_number);
                rv = 0;
                goto end;
            }
        }
    }

end:
    printf("serial number: %s\n", !rv ? serial_number : "");
    return !rv ? serial_number : NULL;
}