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
    auto stattime = Clock.currTime();

    string rel = "";

    if(args.length < 4) {
        writeln("Usage: " ~ args[0] ~ " IMDB_ID Season Episode (Release)");
        exit(0);
    } else if(args.length == 5)
        rel = args[4];

    auto rarbg = new RarbgSource();
    foreach(link; rarbg.searchEpisode(to!int(args[1]), to!int(args[2]), to!int(args[3]), rel)){
        writeln("RESULT: " ~ link);
    }

	writeln("RARBG ==> ", Clock.currTime() - stattime);
    stattime = Clock.currTime();

    auto eztv = new EztvSource();
    foreach(link; eztv.searchEpisode(to!int(args[1]), to!int(args[2]), to!int(args[3]), rel)){
        writeln("RESULT: " ~ link);
    }

	writeln("EZTV ==> ", Clock.currTime() - stattime);
}