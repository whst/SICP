(define (deriv expr var)
  (cond ((number? expr) 0)
        ((variable? expr) (if (same-variable? expr var) 1 0))
        ((sum? expr) (make-sum (deriv (addend expr) var)
                               (deriv (augend expr) var)))
        ((product? expr)
         (make-sum (make-product (multiplier expr)
                                 (deriv (multiplicand expr) var))
                   (make-product (deriv (multiplier expr) var)
                                 (multiplicand expr))))
        ((exponentiation? expr)
         (let ((n (exponent expr)))
          (make-product
            n
            (make-product (make-exponentiation (base expr) (- n 1))
                          (- exponent 1)))))
        (else (error "unknown exprression type: DERIV" expr))))

(define variable? symbol?)

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? expr num) (and (number? expr) (= expr num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (make-exponentiation base exponent)
  (cond ((= exponent 0) 1)
        ((= exponent 1) base)
        (else (list '** base exponent))))

(define (sum? x) (and (pair? x) (eq? (car x) '+)))
(define addend cadr)
(define (augend expr) (caddr expr))

(define (product? x) (and (pair? x) (eq? (car x) '*)))
(define multiplier cadr)
(define (multiplicand expr) (caddr expr))

(define (exponentiation? x)
  (and (pair? x)
       (eq? (car x) '**)))
(define base cadr)
(define exponent caddr)
