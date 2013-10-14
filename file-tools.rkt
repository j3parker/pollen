#lang racket/base
(require racket/contract)
(require (only-in racket/path filename-extension))
(require "world.rkt" "readability.rkt")

(provide (all-defined-out))

(module+ test (require rackunit))


; helper functions for regenerate functions
(define pollen-project-directory (current-directory))

;; this is for regenerate module.
;; when we want to be friendly with inputs for functions that require a path.
;; Strings & symbols often result from xexpr parsing
;; and are trivially converted to paths.
;; so let's say close enough.
(define/contract (pathish? x)
  (any/c . -> . boolean?)
  (->boolean (or path? string? symbol?)))

;; does path have a certain extension
(define/contract (has-ext? x ext)
  (pathish? stringish? . -> . boolean?)
  (define ext-of-path (filename-extension (->path x)))
  (and ext-of-path (equal? (bytes->string/utf-8 ext-of-path) (->string ext))))

(module+ test
  (define foo-path-strings '("foo" "foo.txt" "foo.bar" "foo.bar.txt"))
  (define-values (foo-path foo.txt-path foo.bar-path foo.bar.txt-path) 
    (apply values (map string->path foo-path-strings)))
  ;; test the sample paths before using them for other tests
  (define foo-paths (list foo-path foo.txt-path foo.bar-path foo.bar.txt-path))
  (for-each check-equal? (map ->string foo-paths) foo-path-strings))


(module+ test
  (check-false (has-ext? foo-path 'txt)) 
  (check-true (foo.txt-path . has-ext? . 'txt))
  (check-true (has-ext? foo.bar.txt-path 'txt))
  (check-false (foo.bar.txt-path . has-ext? . 'doc))) ; wrong extension


;; get file extension as a string
(define/contract (get-ext x)
  (pathish? . -> . string?)
  (bytes->string/utf-8 (filename-extension (->path x))))

(module+ test
  (check-equal? (get-ext (->path "foo.txt")) "txt")
  ;; todo: how should get-ext handle input that has no extension?
  ;(check-equal? (get-ext (->path "foo")) "")
  )


;; put extension on path
(define/contract (add-ext x ext)
  (pathish? stringish? . -> . path?)
  (->path (string-append (->string x) "." (->string ext))))

(module+ test
  (check-equal? (add-ext (string->path "foo") "txt") (string->path "foo.txt")))

;; take one extension off path
(define/contract (remove-ext x)
  (pathish? . -> . path?)
  (path-replace-suffix (->path x) ""))

(module+ test  
  (check-equal? (remove-ext foo-path) foo-path)
  (check-equal? (remove-ext foo.txt-path) foo-path)
  (check-equal? (remove-ext foo.bar.txt-path) foo.bar-path)
  (check-not-equal? (remove-ext foo.bar.txt-path) foo-path)) ; does not remove all extensions


;; take all extensions off path
(define/contract (remove-all-ext x)
  (pathish? . -> . path?)
  (define path (->path x))
  (define path-with-removed-ext (remove-ext path))
  (if (equal? path path-with-removed-ext)
      path
      (remove-all-ext path-with-removed-ext)))

(module+ test  
  (check-equal? (remove-all-ext foo-path) foo-path)
  (check-equal? (remove-all-ext foo.txt-path) foo-path)
  (check-not-equal? (remove-all-ext foo.bar.txt-path) foo.bar-path) ; removes more than one ext
  (check-equal? (remove-all-ext foo.bar.txt-path) foo-path))


;; todo: tests for these predicates

(define/contract (preproc-source? x)
  (any/c . -> . boolean?)
  (has-ext? (->path x) POLLEN_PREPROC_EXT))

(module+ test
  (check-true (preproc-source? "foo.pp"))
  (check-false (preproc-source? "foo.bar")))

(define/contract (has-preproc-source? x)
  (any/c . -> . boolean?)
  (file-exists? (->preproc-source-path (->path x))))

(define/contract (has-pollen-source? x)
  (any/c . -> . boolean?)
  (file-exists? (->pollen-source-path (->path x))))

(define/contract (needs-preproc? x)
  (any/c . -> . boolean?)
  ; it's a preproc source file, or a file that's the result of a preproc source
  (ormap (λ(proc) (proc (->path x))) (list preproc-source? has-preproc-source?)))

(define/contract (needs-template? x)
  (any/c . -> . boolean?)
  ; it's a pollen source file
  ; or a file (e.g., html) that has a pollen source file
  (ormap (λ(proc) (proc (->path x))) (list pollen-source? has-pollen-source?)))

(define/contract (ptree-source? x)
  (any/c . -> . boolean?)
  (has-ext? x POLLEN_TREE_EXT))

(module+ test
  (check-true (ptree-source? "foo.ptree"))
  (check-false (ptree-source? "ptree.bar")))


(define/contract (pollen-source? x)
  (any/c . -> . boolean?)
  (has-ext? x POLLEN_SOURCE_EXT))

(module+ test
  (check-true (pollen-source? "foo.p"))
  (check-false (pollen-source? "foo.pp")))


(define/contract (template-source? x)
  (any/c . -> . boolean?)
  (define-values (dir name ignore) (split-path x))
  (equal? (get (->string name) 0) TEMPLATE_FILE_PREFIX))

(module+ test
  (check-true (template-source? "-foo.html"))
  (check-false (template-source? "foo.html")))


;; predicate for files that are eligible to be required
;; from the project/require directory
;; todo: extend this beyond just racket files?
(define/contract (project-require-file? x)
  (any/c . -> . boolean?)
  (has-ext? x 'rkt))

(module+ test
  (check-true (project-require-file? "foo.rkt"))
  (check-false (project-require-file? "foo.html")))



;; todo: tighten these input contracts
;; so that, say, a source-path cannot be input for make-preproc-source-path
(define/contract (->preproc-source-path x)
  (pathish? . -> . path?)
  (->path (if (preproc-source? x)
              x
              (add-ext x POLLEN_PREPROC_EXT))))

(module+ test
  (check-equal? (->preproc-source-path (->path "foo.pp")) (->path "foo.pp"))
  (check-equal? (->preproc-source-path (->path "foo.html")) (->path "foo.html.pp"))
  (check-equal? (->preproc-source-path "foo") (->path "foo.pp"))
  (check-equal? (->preproc-source-path 'foo) (->path "foo.pp")))

(define/contract (->output-path x)
  (pathish? . -> . path?)
  (->path 
   (if (or (pollen-source? x) (preproc-source? x))
       (remove-ext x)
       x)))

(module+ test
  (check-equal? (->output-path (->path "foo.ptree")) (->path "foo.ptree"))
  (check-equal? (->output-path "foo.html") (->path "foo.html"))
  (check-equal? (->output-path 'foo.html.p) (->path "foo.html"))
  (check-equal? (->output-path (->path "/Users/mb/git/foo.html.p")) (->path "/Users/mb/git/foo.html"))
  (check-equal? (->output-path "foo.xml.p") (->path "foo.xml"))
  (check-equal? (->output-path 'foo.barml.p) (->path "foo.barml")))

;; turns input into corresponding pollen source path
;; does not, however, validate that new path exists
;; todo: should it? I don't think so, sometimes handy to make the name for later use
;; OK to use pollen source as input (comes out the same way)
(define/contract (->pollen-source-path x)
  (pathish? . -> . path?)
  (->path (if (pollen-source? x)
              x
              (add-ext x POLLEN_SOURCE_EXT))))

(module+ test
  (check-equal? (->pollen-source-path (->path "foo.p")) (->path "foo.p"))
  (check-equal? (->pollen-source-path (->path "foo.html")) (->path "foo.html.p"))
  (check-equal? (->pollen-source-path "foo") (->path "foo.p"))
  (check-equal? (->pollen-source-path 'foo) (->path "foo.p")))

(define/contract (project-files-with-ext ext)
  (symbol? . -> . (listof complete-path?))
  (map ->complete-path (filter (λ(i) (has-ext? i ext)) (directory-list pollen-project-directory))))

;; todo: write tests for project-files-with-ext