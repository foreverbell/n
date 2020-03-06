{-# LANGUAGE OverloadedStrings #-}

import Data.Default
import Hakyll
import Text.Pandoc.Options
import Text.Pandoc (HTMLMathMethod)

mdWriterTemplate :: String
mdWriterTemplate = concat
  [ "<button type=\"button\" onclick=\"edit()\">Edit</button>\n"
  , "<div id=\"TOC\">$toc$</div>\n"
  , "<hr>\n"
  , "<div id=\"markdownBody\">$body$</div>"
  ]

main :: IO ()
main = hakyll $ do
  match "static/images/*" $ do
    route   idRoute
    compile copyFileCompiler

  match "static/css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match "markdown-cheatsheet.md" $ do
    route (setExtension "html")
    compile $
      pandocCompilerWith
        (def { readerStandalone = True
             , readerExtensions = githubMarkdownExtensions })
        def
      >>= loadAndApplyTemplate "static/templates/post.html"    defaultContext
      >>= loadAndApplyTemplate "static/templates/default.html" defaultContext
      >>= relativizeUrls

  match "n/*" $ do
    route (setExtension "html")
    compile $
      pandocCompilerWith
        (def { readerStandalone = True
             , readerExtensions = githubMarkdownExtensions })
        (def { writerTableOfContents = True
             , writerSectionDivs = True
             , writerHTMLMathMethod = MathML
             , writerTemplate = Just mdWriterTemplate })
      >>= loadAndApplyTemplate "static/templates/post.html"    defaultContext
      >>= loadAndApplyTemplate "static/templates/default.html" defaultContext
      >>= relativizeUrls

  create ["index.html"] $ do
    route idRoute
    compile $ do
      posts <- loadAll "n/*"
      let archiveContext = mconcat
            [ listField "posts" defaultContext (return posts)
            , constField "title" "Notes"
            , defaultContext
            ]
      makeItem ""
        >>= loadAndApplyTemplate "static/templates/archive.html" archiveContext
        >>= loadAndApplyTemplate "static/templates/default.html" archiveContext
        >>= relativizeUrls

  match "static/templates/*" $ do
    compile templateBodyCompiler
