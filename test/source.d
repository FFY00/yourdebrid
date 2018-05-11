/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module test.source;

import yourdebrid.external.sources.source, yourdebrid.external.sources.eztv, yourdebrid.external.sources.rarbg;
import test.source_imp;

void main()
{
    Source source;
    source = new EztvSource;
    source = new RarbgSource;
}