import urllib.request
import os
#
# Generally download hud data files
# Change 2017,2016,2015 format to xls
# Need to clean break linkes of txt files in the feature
#

def download(folder):
    urllib.request.urlretrieve("https://www2.census.gov/programs-surveys/metro-micro/geographies/reference-files/2007/historical-delineation-files/list1.txt",folder + str("CBSA2007.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il17/Section8-FY17.xlsx", folder + str("hudincome2017.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il16/Section8-FY16.xlsx" , folder + str("hudincome2016.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il15/Section8_Rev.xlsx" 	,folder + str("hudincome2015.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il14/Poverty.xls"  , folder + str("hudincome2014.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il13/Section8.xls" , folder + str("hudincome2013.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il12/Section8.xls" 	, folder + str("hudincome2012.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il11/Section8_v3.xls" 	, folder + str("hudincome2011.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il10/Section8.xls" , folder + str("hudincome2010.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il09/Section8.xls" , folder + str("hudincome2009.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il08/Section8_FY08.xls" 	, folder + str("hudincome2008.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il07/Section8-rev.xls" , folder + str("hudincome2007.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il06/Section8FY2006.xls" ,folder + str("hudincome2006.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/il05/Section8FY2005.xls" , folder + str("hudincome2005.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/IL/IL04/Section8.xls" 	, folder + str("hudincome2004.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/IL/FMR03/Section8.xls" 	, folder + str("hudincome2003.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmr02/prts801_02.xls" ,folder + str("hudincome2002.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/IL/FMR01/incfy01.xls" , folder + str("hudincome2001.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/IL/FMR00/incfy00.xls" , folder + str("hudincome2000.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmr99rev/Rev-FY99-30percent.xls" , folder + str("hudincome1999.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmr99/incfy99.xls" , folder + str("hudincome1999original.xls"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmr98/allstate.txt" 	, folder + str("hudincome1998.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmr97/allstate.txt" 	, folder + str("hudincome1997.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmr96/allstate.txt" 	, folder + str("hudincome1996.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmrold/fy95s8.doc" 	, folder + str("hudincome1995.doc"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmrold/fy94s8.doc" , folder + str("hudincome1994.doc"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmrold/LIMS93all.txt" , folder + str("hudincome1993.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmrold/LIMS92all.txt" 	,folder + str("hudincome1992.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmrold/LIMS91all.txt", folder + str("hudincome1991.txt"))
    urllib.request.urlretrieve("https://www.huduser.gov/portal/datasets/il/fmrold/S8lims90.txt" , folder + str("hudincome1990.txt"))



path = input("Enter path:- ")
download(path)