import argparse
import csv
from unidecode import unidecode
from urllib.request import urlopen,FancyURLopener, Request
from urllib.parse import urlencode
import json
import pandas as pd


#DEVELOPER_KEY = "AIzaSyC-jyDUQt1sCnV3SkY2Eoqj0yjtPhzllF8"
DEVELOPER_KEY ="AIzaSyBtu5wIfJFC4TtSHvT94-9CFxIFRZZn2uM"
YOUTUBE_SEARCH_URL = "https://www.googleapis.com/youtube/v3/videos"
#YOUTUBE_VIDEO_URL = "https://www.googleapis.com/youtube/v3/videos"

def openURL(url, parms):
    """
    This function returns a dataset that matches values in parms.
    """
    headers ={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1),AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.3'}
    newURL = url+"?"+urlencode(parms)
    req = Request(url=newURL, headers=headers) 
    f = urlopen(req)
    print(newURL)
    data = f.read()
    f.close()
    matched_data = data.decode("utf-8")
    return matched_data

def youtube_search(options,ID,parms):

    match_result = openURL(YOUTUBE_SEARCH_URL, parms)
    search_response = json.loads(match_result)
    
    # Get next page's token.
    nextPageToken = search_response.get("nextPageToken")

    for search_result in search_response.get("items", []):
        if search_result["kind"] == "youtube#video":
            try:
                tags = search_result["snippet"]["tags"]  
            except KeyError:
                tags =""     
            try:    
                commentCount = search_result["statistics"]["commentCount"]
            except KeyError:
                commentCount = 0
            duration = search_result["contentDetails"]["duration"]
            videoId = ID
           # video_parms = {"id": videoId, "part": "statistics, snippet","chart":"mostPopular","key": DEVELOPER_KEY}                  
        csvWriter.writerow([videoId,commentCount,duration,tags])                
    page_count = 0
    #exit()
    
    # Begin to parse next page's content.
    #while page_count <= options.page_num:
    # while True:
    #     parms.update({"PageToken": nextPageToken})
    #     match_result = openURL(YOUTUBE_SEARCH_URL, parms)
    #     search_response = json.loads(match_result)
    #     nextPageToken = search_response.get("nextPageToken")
        
    #     for search_result in search_response.get("items", []):
    #         if search_result["kind"] == "youtube#video":
    #             tags = search_result["snippet"]["tags"]           
    #             commentCount = search_result["statistics"]["commentCount"]
    #             duration = search_result["contentDetails"]["duration"]
    #             videoId = ID
    #             # video_parms = {"id": videoId, "part": "statistics, snippet","chart":"mostPopular","key": DEVELOPER_KEY}                  
    #         csvWriter.writerow([videoId,commentCount,duration,tags])      
    #     page_count+=1

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "Search on YouTube")

    # Parse the search term.
    parser.add_argument("--q", help = "Search term", default = "Google")

    # Parse maximum results.
    parser.add_argument("--max-results", help = "Max results", default = 50)

    # Parse number of pages to be crawled.
    parser.add_argument("--page-num", help = "Number of pages to be pulled", default = 20)
    
    args = parser.parse_args()
    df = pd.read_csv("select_final_tag.csv")
    ID_list =df["ID"].values

    # Begin to write the data to a csv file.
    csvFile = open("tag_result_tag.csv", "w")
    csvWriter = csv.writer(csvFile)
    csvWriter.writerow(["videoId","commentCount","duration","tags"])
    for ID in ID_list:            
        parms = {
            "part": "snippet,statistics,contentDetails", 
            "id":ID,
            "key": DEVELOPER_KEY,
            }
        youtube_search(args,ID,parms)
