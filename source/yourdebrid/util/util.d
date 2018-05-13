/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module source.yourdebrid.util.util;
import std.datetime;

/**
 * Sleep function
 * Params:
 *      millisec =  Delay duration
 */
int delay(int millisec)
{
    auto const end_time = Clock.currTime() + dur!"msecs"(millisec);

    while(end_time != Clock.currTime()){}

    return millisec;
}
