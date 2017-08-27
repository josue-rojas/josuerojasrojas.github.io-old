from __future__ import division
import requests, json, os
'''
this is to automate getting content for my portfolio from github
# end points useful to me
# curl -X GET https://api.github.com/users/josuerojasrojas/repos
# get the avatar to automate updates
# get name of repo
# get html_url
# get description
# get created_at
# get language
# ge languages_url better language from this compile a list of languages
'''

# user = requests.get('https://api.github.com/users/josuerojasrojas').json()
# need to fix authentication or maybe i passed my limits.....
repos = requests.get('https://api.github.com/users/josuerojasrojas/repos',auth=('josuerojasrojas',os.environ['gittoken'])).json()
allLanguages = set([])

def getAvatar():
    return repos[0]['owner']['avatar_url']

def languagePercent(langs):
    total = 0
    for language in langs.keys():
        total+= langs[language]
        allLanguages.add(language) #this should be more locally scope but this works fine for now
    for language in langs.keys():
        langs[language] = (langs[language]/total) * 100
    return langs

# i am sure there is a better way to filter the data
# ill do that later
def getInfo():
    repoNames = []
    htmlURL = []
    repoDesc = []
    createAt = []
    languages = []
    for repo in repos:
        repoNames.append(repo['name'] if repo['name'] else '')
        htmlURL.append(repo['html_url'] if repo['html_url'] else '')
        repoDesc.append(repo['description'] if repo['description'] else '')
        createAt.append(repo['created_at'] if repo['created_at'] else '')
        languages.append(languagePercent(requests.get(repo['languages_url']).json()) if repo['languages_url'] else [])
    return repoNames, htmlURL, repoDesc, createAt, languages

# this returns a json object (how i wanted)
# getInfo() should be run first to get allLanguages
def organizeData(repoNames, htmlURL, repoDesc, createAt, languages, allLanguages=allLanguages):
    # make each repo json
    repoJson = []
    for i in range(len(repoNames)):
        repoJson.append({
        'repo_name': repoNames[i],
        'url': htmlURL[i],
        'description': repoDesc[i],
        'languages': languages[i]
        })
    dataJson = {
        'avatar_url': getAvatar(),
        'languages':list(allLanguages),
        'repos': repoJson
    }
    return dataJson

def main():
    repoNames, htmlURL, repoDesc, createAt, languages = getInfo()
    with open('data.json','w') as jsonfile:
        json.dump(organizeData(repoNames, htmlURL, repoDesc, createAt, languages), jsonfile)
    os.chdir(os.getcwd())
    os.system('cd '+ os.getcwd()+ '; json2yaml data.json > data.yml') #it's easier to use so i've heard, plus it looks pretty

main()