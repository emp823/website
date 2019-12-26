#lang racket
(require web-server/servlet)
(require web-server/servlet-env)
(require web-server/templates)

; start: request -> response
; Consumes a request, and produces a page that displays all of the
; web content.
(define (start request)
  (dispatch request))

; URL routing table (URL dispatcher).
(define-values (dispatch generate-url)
  (dispatch-rules
    [("") home-page]
    [else (error "There is no procedure to handle the url.")]))

; Helper procedure to make returning HTTP responses easier.
(define (http-response content status-code)
  (response/xexpr `(html ,content)
                  #:code status-code))

; home-page: request -> response
; Home page
(define (home-page request)
  (let
    ([content (include-template "templates/index.html")])
      (http-response (include-template/xml "templates/base.html") 200)))

; respond-unknown-file: request -> response
; When page not found, renders this page
(define (respond-unknown-file request)
  (let
    ([content (include-template "templates/unknown-file.html")])
      (http-response (include-template/xml "templates/base.html") 404)))

; start the server
(serve/servlet start
               #:servlet-path "/"
               #:server-root-path (current-directory)
               #:extra-files-paths (list (build-path "templates"))
               #:file-not-found-responder respond-unknown-file
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 8000)
