/**
* \copyright
* MIT License
*
* Copyright (c) 2018 Infineon Technologies AG
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE
*
* \endcopyright
*
* \author Infineon Technologies AG
*
* \file pal_os_timer.c
*
* \brief   This file implements the platform abstraction layer APIs for timer.
*
* \ingroup  grPAL
* @{
*/

#include <errno.h>
#include <sys/time.h> 
#include <stdio.h>
#include "stdint.h"
#include <time.h>
#include <unistd.h>
#include "pal_os_timer.h"

#if IFX_I2C_LOG_PAL == 1
#include <stdio.h>
#define LOG(...)  printf(__VA_ARGS__)
#else
#define LOG(...)
#endif

#define ERR(...)  fprintf(stderr, __VA_ARGS__)
#define LOG_PREFIX "[IFX-PAL-OS-TIMER] "

uint32_t pal_os_timer_get_time_in_milliseconds()
{
    uint32_t       now_ms = 0;
    struct timeval tv;

    // gettimeofday() returns 0 for success, or -1 for failure
    if (0 == gettimeofday(&tv, NULL))
    {
    	now_ms = ((tv.tv_sec * 1000) + (tv.tv_usec / 1000));
    }
    else
    {
    	now_ms = 0;
    	exit(-1);
    }
    //LOG(LOG_PREFIX "pal_os_timer_get_time_in_milliseconds() <\n");
    return now_ms;
}


void pal_os_timer_delay_in_milliseconds(uint16_t milliseconds)
{
    struct timespec deadline;

    clock_gettime(CLOCK_MONOTONIC, &deadline);

    deadline.tv_sec += milliseconds / 1000;
    deadline.tv_nsec += (milliseconds % 1000) * 1000*1000;

    /* Sleep until deadline */
    while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &deadline, NULL) != 0) {
        if (errno != EINTR) {
            /* error handling here */
            break;
        }
    }
}

/**
* @}
*/

