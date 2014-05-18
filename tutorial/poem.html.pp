#lang pollen
<!DOCTYPE html>
<html>
<head>
◊(define inner 0.5)
◊(define edge (* inner 4))
◊(define color "blue")
<style type="text/css">
pre {
    margin: ◊|edge|em;
    border: ◊|inner|em solid ◊|color|;
    padding: ◊|inner|em;
}
</style>
</head>
<body>
<pre>
The margin is ◊|edge|em.
The border is ◊|color|.
The padding is ◊|inner|em.
The border is too.
</pre>
</body>
</html>