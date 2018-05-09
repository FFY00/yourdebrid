/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module test.test;

import std.getopt, core.stdc.stdlib, std.datetime, std.stdio, std.conv;
import yourdebrid.external.sources.eztv, yourdebrid.external.sources.rarbg;
import test.source_imp;

void main(string[] args)
{
    auto const stattime = Clock.currTime();

    string rel = "";

    if(args.length < 2) {
        writeln("Usage: " ~ args[0] ~ " IMDB_ID (Release)");
        exit(0);
    } else if(args.length == 3)
        rel = args[2];

    // Beautiful Creatures: 1559547
    auto rarbg = new RarbgSource();
    foreach(link; rarbg.searchMovie(to!int(args[1]), rel)){
        writeln("RESULT: " ~ link);
    }

	writeln("RARBG ==> ", Clock.currTime() - stattime);
}