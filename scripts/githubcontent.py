from __future__ import division
import requests
'''
this is to automate getting content for my portfolio from github
it will create a json file like:
{
'github':{
    'languages':...;
    'repoos':{
        'example':{
            'language':'java';,
            'summary': 'chickennuggets and stuff',
            'created':'yesterday'
            },
        'example2':{
            'language':'java';,
            'summary':'eggs and stuff',
            'create':'june 2015'
            }
        }
    }
}
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
repos = requests.get('https://api.github.com/users/josuerojasrojas/repos').json()
allLanguages = set([])

def getAvatar():
    return repos[0]['owner']['avatar_url']

def languagePercent(langs):
    total = 0
    print langs
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
    print allLanguages
    return repoNames, htmlURL, repoDesc, createAt, languages

def main():
    print getInfo()
main()
