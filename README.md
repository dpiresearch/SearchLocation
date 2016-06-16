SearchLocation
==============

Find which keywords are popular in what locations.  Data munging and ip to latlng conversion using Python and Apache Pig.
utilizing the Maxmind community database:

http://dev.maxmind.com/geoip/legacy/geolite/

http://public.tableausoftware.com/views/MX_KW/bubblechart_kw?:embed=y&:display_count=no

## Details
This was a side project I created to use the public Maxmind geo ip database.  I had access to a list of keywords, their associated counts, and the ip address where the keywords originated.  

I first got a tab delimited file with the following columns

| country code (int)| ip address (text)| keyword (text)| count (int) |

and fed that through py/convertIP.py

The output gave me the same lines, except the ip addresses are now replaced by a number representation of the ip address (aka ASN)

The LatLngs associated with the ASN can be find via the Maxmind database.  This was achieved by the pig script pig/getSearchLatLng.pig

The resulting file was then fed into Tableau to achieve the resulting visualization

http://public.tableausoftware.com/views/MX_KW/bubblechart_kw?:embed=y&:display_count=no
