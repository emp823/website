#lang racket
(require web-server/servlet)
(require web-server/servlet-env)
(require web-server/templates)

; A blog is a (listof post)
; and a post is a (post title body)
(struct post (title body))
 
; start: request -> response
; Consumes a request, and produces a page that displays all of the
; web content.
(define (start request)
  (render-blog-page request))
 
; render-blog-page: blog request -> response
; Consumes a blog and a request, and produces an HTML page
; of the content of the blog.
(define (render-blog-page request)
  (response/xexpr
    `(html ,(include-template/xml "index.html"))))


; start the server
(serve/servlet start
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 8000
               #:extra-files-paths
               (list (build-path "/htdocs" "htdocs"))
               #:servlet-path
               "/home")