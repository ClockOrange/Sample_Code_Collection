import argparse
import csv
from unidecode import unidecode
from urllib.request import urlopen,FancyURLopener, Request
from urllib.parse import urlencode
import json
import pandas as pd

DEVELOPER_KEY ="AIzaSyBdazYWqscmDK7Cd9BqrWUJ9f1bKbHa_LE"
#DEVELOPER_KEY ="AIzaSyBtu5wIfJFC4TtSHvT94-9CFxIFRZZn2uM"
YOUTUBE_SEARCH_URL = "https://www.googleapis.com/youtube/v3/commentThreads"
YOUTUBE_COMMENT_URL = "https://www.googleapis.com/youtube/v3/comments"


def openURL(url, parms):
    """
    This function returns a dataset that matches values in parms.
    """
    headers ={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1),AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.3'}
    newURL = url+"?"+urlencode(parms)
    print(newURL)
    req = Request(url=newURL, headers=headers) 
    f = urlopen(req)
   
    data = f.read()
    f.close()
    matched_data = data.decode("utf-8")
    return matched_data

def youtube_search(options,ID,parms):
    match_result = openURL(YOUTUBE_SEARCH_URL, parms)
    search_response = json.loads(match_result)
    videoId = ID
    
    # Get next page's token.
    nextPageToken = search_response.get("nextPageToken")

    for search_result in search_response.get("items", []):
        if search_result["kind"] == "youtube#commentThread":
            c_id = search_result["id"]
            print(c_id)
            video_parms = {"id": c_id, "part": "snippet","key": DEVELOPER_KEY}
            video_match_result = openURL(YOUTUBE_COMMENT_URL, video_parms)
            video_response = json.loads(video_match_result)

            for com_result in video_response.get("items",[]):
                if com_result["kind"] == "youtube#comment":
                    if 'likeCount' not in com_result["snippet"]:
                        likecount = 0
                    else:
                        likecount = com_result["snippet"]["likeCount"]
                    print(likecount)
                    if 'textDisplay' not in com_result["snippet"]:
                        comment=""
                    else:
                        content = com_result["snippet"]["textDisplay"]
                        comment = unidecode(content)
           # video_parms = {"id": videoId, "part": "statistics, snippet","chart":"mostPopular","key": DEVELOPER_KEY}                  
            csvWriter.writerow([videoId,likecount,comment])                
    page_count = 0
 
    
    # # Begin to parse next page's content.
    # while page_count <= 20:
    #     while True:
    #         parms.update({"PageToken": nextPageToken})
    #         match_result = openURL(YOUTUBE_SEARCH_URL, parms)
    #         search_response = json.loads(match_result)
    #         nextPageToken = search_response.get("nextPageToken")
    #         videoId = ID
    #         for search_result in search_response.get("items", []):
    #             if search_result["kind"] == "youtube#commentThread":
    #                 c_id = search_result["id"]
    #                 print(c_id)
    #                 video_parms = {"id": c_id, "part": "snippet","key": DEVELOPER_KEY}
    #                 video_match_result = openURL(YOUTUBE_COMMENT_URL, video_parms)
    #                 video_response = json.loads(video_match_result)

    #                 for com_result in video_response.get("items",[]):
    #                     if com_result["kind"] == "youtube#comment":
    #                         if 'likeCount' not in com_result["snippet"]:
    #                             likecount = 0
    #                         else:
    #                             likecount = com_result["snippet"]["likeCount"]
    #                         print(likecount)
    #                         if 'textDisplay' not in com_result["snippet"]:
    #                             comment=""
    #                         else:
    #                             content = com_result["snippet"]["textDisplay"]
    #                             comment = unidecode(content)
    #                     # video_parms = {"id": videoId, "part": "statistics, snippet","chart":"mostPopular","key": DEVELOPER_KEY}                  
    #                 csvWriter.writerow([videoId,likecount,comment])           
    #         page_count+=1

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "Search on YouTube")

    # Parse the search term.
    parser.add_argument("--q", help = "Search term", default = "Google")

    # Parse maximum results.
    parser.add_argument("--max-results", help = "Max results", default = 100)

    # Parse number of pages to be crawled.
    parser.add_argument("--page-num", help = "Number of pages to be pulled", default = 20)
    
    args = parser.parse_args()
    df = pd.read_csv("ChannelVideo.csv")[18:]
    ID_list =df["ID"].values

    # Begin to write the data to a csv file.
    csvFile = open("AllComment02.csv", "w")
    csvWriter = csv.writer(csvFile)
    csvWriter.writerow(["videoId","likeCount","comment"])
    for ID in ID_list:
        parms = {
        "part": "id,snippet", 
        "maxResults": 100,
        "order" :"relevance",
        "videoId":ID,
        "key": DEVELOPER_KEY
        }
        try:
            youtube_search(args,ID,parms)
        except TypeError:
            pass

