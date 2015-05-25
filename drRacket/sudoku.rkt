(require "a10lib.rkt")

;;
;;***************************************
;; Karen Lu (20556077)
;; CS 135 Fall 2014
;; Assignment 10 Problem 3 (sudoku)
;;***************************************
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A SudokuDigit is one of:
;; * '?
;; * 1 <= Nat <= 9

;; A Pos (position) is a Nat.
;; requires: 11 <= Pos <= 99
;;           neither digit can be zero or greater 9

;; A Puzzle is a (listof (listof (oneof SudokuDigit Pos)))
;; requires: the list and all sublists have a length of 9

;; A Solution is a Puzzle
;; requires: none of the SudokuDigits are '? or Pos
;;           the puzzle satisfies the number placement 
;;             rules of sudoku

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants:
(define box-length 3)
(define box-first 1)
(define box-second 2)
(define box-third 3)
(define max-digit 9)
(define tens 10)
(define first-of-puzzle 1)
(define no-pos 0)
(define lod (build-list 9 add1))
(define pos-list
  '((11 12 13 14 15 16 17 18 19)
    (21 22 23 24 25 26 27 28 29)
    (31 32 33 34 35 36 37 38 39)
    (41 42 43 44 45 46 47 48 49)
    (51 52 53 54 55 56 57 58 59)
    (61 62 63 64 65 66 67 68 69)
    (71 72 73 74 75 76 77 78 79)
    (81 82 83 84 85 86 87 88 89)
    (91 92 93 94 95 96 97 98 99)))

;; Sample sudoku puzzles:
(define veryeasy
  '((? 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

;; the above puzzle with more blanks:
(define easy
  '((? 4 5 8 ? 3 7 1 ?)
    (8 1 ? ? ? ? ? 2 4)
    (7 ? 9 ? ? ? 5 ? 8)
    (? ? ? 9 ? 7 ? ? ?)
    (? ? ? ? 6 ? ? ? ?)
    (? ? ? 4 ? 2 ? ? ?)
    (6 ? 4 ? ? ? 3 ? 5)
    (3 2 ? ? ? ? ? 8 7)
    (? 5 7 3 ? 8 2 6 ?)))

;; the puzzle listed on wikipedia
(define wikipedia '((5 3 ? ? 7 ? ? ? ?)
                    (6 ? ? 1 9 5 ? ? ?)
                    (? 9 8 ? ? ? ? 6 ?)
                    (8 ? ? ? 6 ? ? ? 3)
                    (4 ? ? 8 ? 3 ? ? 1)
                    (7 ? ? ? 2 ? ? ? 6)
                    (? 6 ? ? ? ? 2 8 ?)
                    (? ? ? 4 1 9 ? ? 5)
                    (? ? ? ? 8 ? ? 7 9)))

(define hard '((5 ? ? 2 9 ? 7 ? ?)
               (? ? ? ? ? ? ? 8 ?)
               (? 7 ? ? ? ? 6 ? 5)
               (? ? ? 1 ? 2 ? ? 3)
               (2 9 ? 4 ? 7 ? 5 1)
               (1 ? ? 5 ? 9 ? ? ?)
               (4 ? 2 ? ? ? ? 9 ?)
               (? 1 ? ? ? ? ? ? ?)
               (? ? 7 ? 1 8 ? ? 2)))

;; A blank puzzle template:
(define blank '((? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)))
;; Solution to veryeasy and easy
(define veryeasy-sol
  '((2 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

;; Solution to wikipedia
(define wiki-sol
  '((5 3 4 6 7 8 9 1 2)
    (6 7 2 1 9 5 3 4 8)
    (1 9 8 3 4 2 5 6 7)
    (8 5 9 7 6 1 4 2 3)
    (4 2 6 8 5 3 7 9 1)
    (7 1 3 9 2 4 8 5 6)
    (9 6 1 5 3 7 2 8 4)
    (2 8 7 4 1 9 6 3 5)
    (3 4 5 2 8 6 1 7 9)))

;; Solution to hard
(define hard-sol
  '((5 3 8 2 9 6 7 1 4)
    (6 2 4 7 5 1 3 8 9)
    (9 7 1 8 4 3 6 2 5)
    (7 8 5 1 6 2 9 4 3)
    (2 9 6 4 3 7 8 5 1)
    (1 4 3 5 8 9 2 7 6)
    (4 6 2 3 7 5 1 9 8)
    (8 1 9 6 2 4 5 3 7)
    (3 5 7 9 1 8 4 6 2)))

;; Solution to blank
(define blank-sol
  '((1 2 3 4 5 6 7 8 9)
    (4 5 6 7 8 9 1 2 3)
    (7 8 9 1 2 3 4 5 6)
    (2 1 4 3 6 5 8 9 7)
    (3 6 5 8 9 7 2 1 4)
    (8 9 7 2 1 4 3 6 5)
    (5 3 1 6 4 2 9 7 8)
    (6 4 2 9 7 8 5 3 1)
    (9 7 8 5 3 1 6 4 2)))




;;***************************HELPER FUNCTIONS************************
;; (trans-board puzzle) replaces every '? in puzzle with its respective
;;   Pos in the constant pos-list.
;; trans-board: Puzzle -> Puzzle
;; Examples:
(check-expect (trans-board veryeasy)
              '((11 4 5 8 9 3 7 1 6)
                (8 1 3 5 7 6 9 2 4)
                (7 6 9 2 1 4 5 3 8)
                (5 3 6 9 8 7 1 4 2)
                (4 9 2 1 6 5 8 7 3)
                (1 7 8 4 3 2 6 5 9)
                (6 8 4 7 2 1 3 9 5)
                (3 2 1 6 5 9 4 8 7)
                (9 5 7 3 4 8 2 6 1)))
(check-expect (trans-board easy)
              '((11 4 5 8 15 3 7 1 19)
                (8 1 23 24 25 26 27 2 4)
                (7 32 9 34 35 36 5 38 8)
                (41 42 43 9 45 7 47 48 49)
                (51 52 53 54 6 56 57 58 59)
                (61 62 63 4 65 2 67 68 69)
                (6 72 4 74 75 76 3 78 5)
                (3 2 83 84 85 86 87 8 7)
                (91 5 7 3 95 8 2 6 99)))

(define (trans-board puzzle)
  (map (lambda (puzzle-row pos-row) 
         (map (lambda (puzzle-num pos) 
                (cond
                  [(symbol? puzzle-num) pos]
                  [else puzzle-num])) 
              puzzle-row pos-row)) puzzle pos-list))

;; Tests:
(check-expect (trans-board blank)
              '((11 12 13 14 15 16 17 18 19)
                (21 22 23 24 25 26 27 28 29)
                (31 32 33 34 35 36 37 38 39)
                (41 42 43 44 45 46 47 48 49)
                (51 52 53 54 55 56 57 58 59)
                (61 62 63 64 65 66 67 68 69)
                (71 72 73 74 75 76 77 78 79)
                (81 82 83 84 85 86 87 88 89)
                (91 92 93 94 95 96 97 98 99)))

;; make-solved? produces a function that takes in the result of a Puzzle
;;   from trans-board and checks that it is a Solution.
;; make-solved?: (Puzzle -> Bool)
;; Examples:
(check-expect (make-solved? (trans-board easy)) false)
(check-expect (make-solved? (trans-board wikipedia)) false)

(define make-solved?
  (lambda (puzzle)
    (andmap (lambda (row) 
              (andmap (lambda (puzzle-num) 
                        (<= puzzle-num max-digit)) 
                      row)) puzzle)))

;; Tests:
(check-expect (make-solved? (trans-board veryeasy)) false)
(check-expect (make-solved? (trans-board veryeasy-sol)) true)
(check-expect (make-solved? (trans-board blank)) false)

;; (neighbours puzzle) produces a list of possible Puzzles with the first
;;   Pos of puzzle filled in with a SudokuDigit.
;; neighbours: Puzzle -> (listof Puzzle)
;; Examples:
(check-expect (neighbours (trans-board veryeasy))
              (list veryeasy-sol))
(check-expect (neighbours (trans-board easy))
              (list '((2 4 5 8 15 3 7 1 19)
                      (8 1 23 24 25 26 27 2 4)
                      (7 32 9 34 35 36 5 38 8)
                      (41 42 43 9 45 7 47 48 49)
                      (51 52 53 54 6 56 57 58 59)
                      (61 62 63 4 65 2 67 68 69)
                      (6 72 4 74 75 76 3 78 5)
                      (3 2 83 84 85 86 87 8 7)
                      (91 5 7 3 95 8 2 6 99))))

(define (neighbours puzzle)
  (local
    [;; (find-pos puzzle) finds the first Pos in puzzle.
     ;; find-pos: Puzzle -> Pos
     (define (find-pos puzzle)
       (local
         [;; (find-pos-r row) produces the first Pos in row. If there
          ;;   are no pos, then zero is returned.
          ;; find-pos-r: (listof SudokuDigit Pos) -> (oneof Pos 0)
          (define (find-pos-r row)
            (cond
              [(empty? row) no-pos]
              [(> (first row) max-digit) (first row)]
              [else (find-pos-r (rest row))]))
          (define pos (cond
                        [(empty? puzzle) no-pos]
                        [else (find-pos-r (first puzzle))]))]
         (cond
           [(empty? puzzle) no-pos]
           [(zero? pos) (find-pos (rest puzzle))]
           [else pos])))
     ;; (insert-digit digit puzzle pos) replaces pos with digit in puzzle.
     ;; insert-digit: SudokuDigit Puzzle Pos -> Puzzle
     ;; requires: SudokuDigit cannot be '?
     (define (insert-digit digit puzzle pos)
       (list (map (lambda (row) 
                    (map (lambda (num) 
                           (cond
                             [(= num pos) digit]
                             [else num])) row)) puzzle)))
     ;; (valid-pos? digit puzzle pos) checks if the digit can replace pos
     ;;   in puzzle and not violate any number placement rules.
     ;; valid-pos?: SudokuDigit Puzzle Pos -> Puzzle
     ;; requires: SudokuDigit cannot be '?
     (define (valid-pos? digit puzzle pos)
       (local
         [(define r (quotient pos tens))
          (define c (remainder pos tens))
          ;; (vertical col puzzle) produces the nth (col) column of puzzle.
          ;; vertical: Nat Puzzle -> (listof SudokuDigit Pos)
          ;; requires col <= 9
          (define (vertical col puzzle)
            (cond
              [(= col first-of-puzzle) (map first puzzle)]
              [else (vertical (sub1 col) (map rest puzzle))]))
          ;; (horizontal row puzzle) produces the nth (row) column of puzzle.
          ;; horizontal: Nat Puzzle -> (listof SudokuDigit Pos)
          ;; requires: row <= 9
          (define (horizontal row puzzle)
            (cond
              [(= row first-of-puzzle) (first puzzle)]
              [else (horizontal (sub1 row) (rest puzzle))]))
          ;; (box r c puzzle) produces the box that contains both r and c 
          ;;   in the puzzle.
          ;; box: Nat Nat Puzzle -> (listof SudokuDigit Pos)
          ;; requires: r <= 9
          ;;           c <= 9
          (define (box r c puzzle)
            (local
              [(define boxr (* (quotient (sub1 r) 
                                         box-length) box-length))
               (define boxc (* (quotient (sub1 c) 
                                         box-length) box-length))
               (define hor-cut
                 (list (horizontal (+ boxr box-first) puzzle)
                       (horizontal (+ boxr box-second) puzzle)
                       (horizontal (+ boxr box-third) puzzle)))]
              (append (vertical (+ boxc box-first) hor-cut)
                      (vertical (+ boxc box-second) hor-cut)
                      (vertical (+ boxc box-third) hor-cut))))]
         (not (or (member? digit (vertical c puzzle))
                  (member? digit (horizontal r puzzle))
                  (member? digit (box r c puzzle))))))
     (define pos (find-pos puzzle))]
    (cond
      [(zero? pos) empty]
      [else
       (append (foldr (lambda (digit rest-digits)
                        (append (insert-digit digit puzzle pos) 
                                rest-digits)) 
                      '() (filter (lambda (digit) 
                                    (valid-pos? digit puzzle pos)) 
                                  lod)))])))

;; Tests:
(check-expect (neighbours veryeasy-sol)
              empty)
(check-expect (neighbours (trans-board wikipedia))
              (list '((5 3 1 14 7 16 17 18 19)
                      (6 22 23 1 9 5 27 28 29)
                      (31 9 8 34 35 36 37 6 39)
                      (8 42 43 44 6 46 47 48 3)
                      (4 52 53 8 55 3 57 58 1)
                      (7 62 63 64 2 66 67 68 6)
                      (71 6 73 74 75 76 2 8 79)
                      (81 82 83 4 1 9 87 88 5)
                      (91 92 93 94 8 96 97 7 9))
                    '((5 3 2 14 7 16 17 18 19)
                      (6 22 23 1 9 5 27 28 29)
                      (31 9 8 34 35 36 37 6 39)
                      (8 42 43 44 6 46 47 48 3)
                      (4 52 53 8 55 3 57 58 1)
                      (7 62 63 64 2 66 67 68 6)
                      (71 6 73 74 75 76 2 8 79)
                      (81 82 83 4 1 9 87 88 5)
                      (91 92 93 94 8 96 97 7 9))
                    '((5 3 4 14 7 16 17 18 19)
                      (6 22 23 1 9 5 27 28 29)
                      (31 9 8 34 35 36 37 6 39)
                      (8 42 43 44 6 46 47 48 3)
                      (4 52 53 8 55 3 57 58 1)
                      (7 62 63 64 2 66 67 68 6)
                      (71 6 73 74 75 76 2 8 79)
                      (81 82 83 4 1 9 87 88 5)
                      (91 92 93 94 8 96 97 7 9))))

;;***************************MAIN FUNCTION************************
;; (sudoku puzzle) produces the solution to puzzle.
;; sudoku: Puzzle -> Solution
;; Examples:
(check-expect (sudoku wikipedia) wiki-sol)
(check-expect (sudoku hard) hard-sol)

(define (sudoku puzzle)
  (find-final (trans-board puzzle) neighbours make-solved?))

;; Tests:
(check-expect (sudoku easy) veryeasy-sol)
(check-expect (sudoku veryeasy) veryeasy-sol)
(check-expect (sudoku blank) blank-sol)
