/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.util;
import std.datetime;

/**
 * Sleep function
 * @param millisec Delat duration
 */
int delay(int millisec)
{
    auto const start_time = Clock.currTime();

    while((start_time + dur!"msecs"(millisec)) != Clock.currTime()){}

    return millisec;
}