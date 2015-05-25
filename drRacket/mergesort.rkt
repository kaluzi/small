;;
;;***************************************
;; Karen Lu (20556077)
;; CS 135 Fall 2014
;; Assignment 10 Problem 1 (a10)
;;***************************************
;;

;; (mergesort lst compare-fn) produces a sorted list according to
;;   compare-fn.
;; mergesort: (listof Any) (Any Any -> Bool) -> (listof Any)
;; Examples:
(check-expect (mergesort '(6 2 5) <) '(2 5 6))
(check-expect (mergesort (list #\e #\c #\v) char>?) 
              (list #\v #\e #\c))

(define (mergesort lst compare-fn)
  (cond
    [(<= (length lst) 1) lst]
    [else
     (local
       [(define half (ceiling (/ (length lst) 2)))
        (define l-lst
          (foldr (lambda (x rest-lst) 
                   (cond
                     [(= (length rest-lst) half) (cons x empty)]
                     [else (cons x rest-lst)])) empty lst))
        
        (define r-lst
          (foldr (lambda (x rest-lst) 
                   (cond
                     [(= (length rest-lst) half) rest-lst]
                     [else (cons x rest-lst)])) empty lst))
        (define (split lst)
          (cond
            [(= (length lst) 1) lst]
            [else (mergesort lst compare-fn)]))
        (define (merge lst1 lst2 compare-fn)
          (cond 
            [(or (empty? lst1) (empty? lst2)) (append lst1 lst2)]
            [(compare-fn (first lst1) (first lst2))
             (cons (first lst1) 
                   (merge (rest lst1) lst2 compare-fn))]
            [else (cons (first lst2) 
                        (merge lst1 (rest lst2) compare-fn))]))]
       (merge (split l-lst) (split r-lst) compare-fn))]))

;; Tests:
(check-expect (mergesort empty <) empty)
(check-expect (mergesort '(6) <) '(6))
(check-expect (mergesort '(5 4 3 2 1) >) '(5 4 3 2 1))
(check-expect (mergesort '(1 2 3 4 5) >) '(5 4 3 2 1))
(check-expect (mergesort '(5 4 2 2 2) <) '(2 2 2 4 5))
(check-expect (mergesort '(5 4 2 2 2) <=) '(2 2 2 4 5))
(check-expect (mergesort '(1 2 3 4 5 6) >) '(6 5 4 3 2 1))
(check-expect (mergesort '("xyz" "hia" "hij") string<?) 
              '("hia" "hij" "xyz"))
