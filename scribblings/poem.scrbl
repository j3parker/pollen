#lang scribble/manual

@(require (for-label pollen/world))

@title{First, a poem}

In this tutorial, you'll use Pollen to make a single HTML page with a poem. You'll learn about:

@itemlist[

@item{The relationship of Racket & Pollen}

@item{The preprocessor}

@item{The project server}

@item{Command syntax}

@item{DrRacket}

@item{@racketfont{raco pollen}}

@item{Project structure}

@item{Using variables to store values}

]

Like many first tutorials, this one is designed for simplicity, and thus is also somewhat contrived. Once you get comfortable with Pollen, you're unlikely to make HTML pages this way. So if you consider yourself a quick study, feel free to skip ahead to the next tutorial. You can always come back.

If you want a shortest possible introduction to Pollen, try the @secref["quick-tour"].

@section{Prerequisites}

I'm going to assume that you've already installed Racket and Pollen. If not, do that now.

I'm also going to assume you know the basics of using a command line to run programs and navigate the file system using commands like @tt{cd} and @tt{ls}. On Mac OS X, your command-line program is called Terminal; on Windows it's the Windows Command Processor.

@section{The relationship of Racket & Pollen}

As I alluded in the @secref["big-picture"], Pollen is built using Racket, and everything in Pollen ultimately becomes Racket code. If you're comfortable with that idea, you may move along. 

But if not, or if you're just a curious character:

One of the key features of Racket as a programming language is that it provides tools to create @italic{other} programming languages. These languages might look & behave @link["http://docs.racket-lang.org/ts-guide/index.html"]{like Racket}. Or they @link["http://hashcollision.org/brainfudge/"]{might not}. These languages might serve a general purpose, but more often they're specialized for a particular purpose, in which case they're known as @italic{domain-specific languages}, or @italic{DSLs}. 

@margin-note{Racket exploits the fact that under the hood, all programming languages are basically doing the same thing. (CS jocks know this more formally as a side effect of @link["https://en.wikipedia.org/wiki/Turing_completeness"]{Turing completeness}.) Racket starts with the most general expression of a Turing-complete language — called @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{the lambda calculus} — and lets users build on that. In most programming languages, you can build functions, classes, and modules. But in Racket, you can alter anything about the language.}

If you find this a strange idea, you're not alone. Most programmers — and until recently, me too — have never made or used DSLs. If you have a programming problem to solve, you start with a general-purpose language like Python or Java or Ruby, and go from there. Nothing wrong with that. 

But programming languages contain their own design choices and compromises. Sometimes the problem at hand is best solved by manipulating the language at a deeper level. When you make a DSL, you're still programming in the underlying language, but doing so at a point of higher leverage.

Pollen is a DSL implemented in Racket. It is a close cousin of @other-doc['(lib "scribblings/scribble/scribble.scrbl")], another Racket DSL, which was designed for writing Racket documentation. The key feature of Scribble, and thus also of Pollen, is that it's text-based. Meaning, whereas most languages have source files made of code with text embedded within, Pollen's source files are text with code embedded within.

Moreover, Pollen is meant to be a small step away from Racket — you can think of it as a more convenient notation system for Racket code, similar to how Markdown is a more convenient notation for HTML. But unlike HTML & Markdown, anything that can be done in Racket can also be done in Pollen. 

As you work more with Pollen, you'll pick up more about how Pollen corresponds to Racket (see @secref["reader"]) and easily be able to convert commands from one system to the other. In later tutorials, you'll see how larger Pollen projects are made out of both Pollen and Racket source files.

But in smaller ones, like this tutorial, you can just use Pollen.

@section{Starting a new file in DrRacket}

DrRacket is the IDE for the Racket programming language, and other languages made with Racket (like Pollen). IDE stands for ``Integrated Development Environment,'' which is fancy talk for ``a nice place to edit and run your code.'' DrRacket is installed as part of the core Racket distribution.

@margin-note{If you've worked with languages like Perl, Python, or Ruby, you may be more familiar with using a general-purpose text editor to edit your code, and then running your program at the command line. You can do that with Racket too. But don't knock DrRacket till you try it. For these tutorials, I'll assume you're using DrRacket. If you insist on the command line, I trust you to figure out what you need to do to keep up.}

Launch DrRacket. Start a new file. The code in the file will look like this:

@racketmod[racket]

You should also see an @italic{interactions window} within the main window, which shows the output of the current file, and starts out looking something like this (details, like the version number, will vary):

@verbatim{
Welcome to DrRacket, version 6.0.1.6--2013-11-26(-/f) [3m].
Language: racket; memory limit: 1000 MB.
> }

If you don't see the interactions window, select @menuitem["View"
"Show Interactions"] from the menu.

@subsection{Setting the @racketfont{#lang} line}

The first line of every Pollen source file, and every Racket source file, is called the @italic{@tt{#lang} line}. The @racketfont{#lang} line identifies the language used to interpret the rest of the file.  

Any time you want to start a new Pollen source file in DrRacket, you'll need to change the @racketfont{#lang} line to the Pollen language. The simplest way is to change the first line to this:

@racketmod[pollen]

Now run your file by clicking the @onscreen["Run"] button in the upper-right corner, or select @menuitem["Racket" "Run"] from the menu. You'll get something like this:

@verbatim{
Welcome to DrRacket, version 6.0.1.6--2013-11-26(-/f) [3m].
Language: pollen; memory limit: 1000 MB.
> 
}

Note that the language is now reported as @racketfont{pollen}. If you like, change the @racketfont{#lang} line to this:

@racketmod[pollenxyz]

Then click @onscreen["Run"] again. DrRacket will print an error in the interactions window that looks like:

@verbatim{@racketerror{Module Language: invalid module text
@(linebreak)standard-module-name-resolver: collection not found ...}}

Why? Because there's no language called @racketfont{pollenxyz}. Switch it back to @racketfont{pollen} and let's move on.

@subsection{Putting in the text of the poem}

You can use any poem that's set in plain text. Here's one you can copy, if you like:

@nested[#:style 'code-inset]{@verbatim{
"Ulysses" by Alfred Tennyson

It little profits that an idle king,
By this still hearth, among these barren crags,
Match'd with an aged wife, I mete and dole
Unequal laws unto a savage race,
That hoard, and sleep, and feed, and know not me.

I cannot rest from travel: I will drink
Life to the lees; all times I have enjoy'd
Greatly, have suffer'd greatly, both with those
That loved me, and alone; on shore, and when
Thro' scudding drifts the rainy Hyades
Vext the dim sea: I am become a name;
For always roaming with a hungry heart
Much have I seen and known; cities of men
And manners, climates, councils, governments,
Myself not least, but honour'd of them all;
And drunk delight of battle with my peers,
Far on the ringing plains of windy Troy,
I am a part of all that I have met;
Yet all experience is an arch wherethro'
Gleams that untravell'd world, whose margin fades
For ever and for ever when I move.
How dull it is to pause, to make an end,
To rust unburnish'd, not to shine in use!
As tho' to breathe were life. Life piled on life
Were all too little, and of one to me
Little remains: but every hour is saved
From that eternal silence, something more,
A bringer of new things; and vile it were
For some three suns to store and hoard myself,
And this gray spirit yearning in desire
To follow knowledge like a sinking star,
Beyond the utmost bound of human thought.

This is my son, mine own Telemachus,
To whom I leave the scepter and the isle --
Well-loved of me, discerning to fulfil
This labour, by slow prudence to make mild
A rugged people, and thro' soft degrees
Subdue them to the useful and the good.
Most blameless is he, centred in the sphere
Of common duties, decent not to fail
In offices of tenderness, and pay
Meet adoration to my household gods,
When I am gone. He works his work, I mine.

There lies the port; the vessel puffs her sail:
There gloom the dark broad seas. My mariners,
Souls that have toil'd, and wrought, and thought with me --
That ever with a frolic welcome took
The thunder and the sunshine, and opposed
Free hearts, free foreheads -- you and I are old;
Old age hath yet his honour and his toil;
Death closes all: but something ere the end,
Some work of noble note, may yet be done,
Not unbecoming men that strove with Gods.
The lights begin to twinkle from the rocks:
The long day wanes: the slow moon climbs: the deep
Moans round with many voices. Come, my friends,
'Tis not too late to seek a newer world.
Push off, and sitting well in order smite
The sounding furrows; for my purpose holds
To sail beyond the sunset, and the baths
Of all the western stars, until I die.
It may be that the gulfs will wash us down:
It may be we shall touch the Happy Isles,
And see the great Achilles, whom we knew.
Tho' much is taken, much abides; and tho'
We are not now that strength which in old days
Moved earth and heaven; that which we are, we are;
One equal temper of heroic hearts,
Made weak by time and fate, but strong in will
To strive, to seek, to find, and not to yield.
}}

Paste the text of the poem into your DrRacket code window, after the @racketfont{#lang} line, so it looks like this:

@nested[#:style 'code-inset]{@verbatim{
#lang pollen

"Ulysses" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}

@onscreen["Run"] the file again. In the interactions window, you'll see:

@nested[#:style 'code-inset]{@racketoutput{
"Ulysses" by Alfred Tennyson
@(linebreak) 
@(linebreak)It little profits that an idle king,
@(linebreak)By this still hearth, among these barren crags, ...}}

This shows you something important: by default, any plain text in a Pollen source file is simply printed as written when you @onscreen["Run"] the file (minus the @racketfont{#lang} line, which is just for Racket's benefit). If you like, edit the text of the poem and click @onscreen["Run"] again. You'll see the updated text printed in the interactions window.

@subsection{Saving & naming your source file}

File naming in Pollen is consequential. Take heed.

Ultimately, every Pollen source file in your project will be @italic{rendered} into an output file. Each Pollen source file corresponds to one output file. @bold{The name of this output file will be the name of the source file minus the Pollen file extension of the source file.} So a source file called @racketfont{file.txt.pp} will become @racketfont{file.txt}.

So here's how we figure out the name of a source file. We take the name we want for the output file and add the appropriate Pollen file extension. There's more than one Pollen file extension — but more about that later. For now, the extension you'll use for your source is @racketfont{.pp}.

In this case, let's say we want to end up with a file called @racketfont{poem.html}. Therefore, the name of our source file needs to be @racketfont{poem.html} plus the file extension @racketfont{.pp} = @racketfont{poem.html.pp}. (If you want to name the file @racketfont{something-else.html.pp}, be my guest. There's no magic associated with the prefix.)

@margin-note{You're welcome to change the name of your source files from the desktop. On Mac OS X and Windows, however, the desktop interface often hides file extensions, so check the properties of the file afterward to make sure you got the name you expected.}

In a convenient location (e.g., your home directory) create a new directory for your project called @racketfont{tennyson} — or whatever you like, there's no magic associated with that name either. In that folder, save your DrRacket file as @racketfont{poem.html.pp}.

@filebox["/path/to/tennyson/poem.html.pp"]{@verbatim{
#lang pollen

"Ulysses" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}


@section{Using the project server}

The project server is a web server built into Pollen. Just as DrRacket lets you run individual files and see if they work as you expect, the project server lets you preview and test your project as a real website. While working on your Pollen project, you may find it convenient to have DrRacket open on half your screen, and on the other half, a web browser pointing at the project server.

@image["project-server.png" #:scale 0.7]

``Why can't I just open the HTML files directly in my browser?'' If you want to keep making web pages the way we did in 1996, go ahead. But that approach has several shortcomings. First, when you open files directly in your browser, you're cruising the local filesystem, and absolute URLs (the kind that start with a @litchar{/}) won't work. Second, if you want to test your website on devices other than your own machine — well, you can't. Third, you'd have to render your HTML files in advance, whereas the project server is clever about doing this dynamically. 

So use the project server.

A note about security. The project server isn't intended for real-world use, but rather as a development tool. That said, once you start the project server, it's an actual web server running on your machine, and it will respond to requests from any computer. If you want to limit traffic to your local network, or certain machines on your local network, it's your job — not mine — to configure your firewall or other network security measures accordingly. You know, the Spider-Man Principle — great power, great responsibility, etc.

You can handle it? All right then. 



@subsection{Starting the project server with @racketfont{raco pollen}}

You start the project server from the command line using the @racketfont{raco pollen} command. @racketfont{raco} is short for @bold{Ra}cket @bold{co}mmand, and acts as a hub for, well, Racket commands. You used it when you first installed Pollen:

@verbatim{
> raco pkg install pollen
}

The first argument after @racketfont{raco} is the subcommand. For instance, @racketfont{raco pkg ...} lets you install, update, and remove packages like so:

@verbatim{
> raco pkg update pollen
> raco pkg remove pollen
}

Likewise, @racketfont{raco pollen} lets you issue commands relevant to Pollen, like starting the project server. (See @secref["raco-pollen"] for a full description of available commands.) Go to your command line and enter the following:

@verbatim{
> cd /path/to/tennyson
> raco pollen start}

@margin-note{Windows users, I'll trust you to convert @racketfont{raco} into the appropriate command for your system — assuming defaults, it's likely to be @racketfont{"C:\Program Files\Racket\raco"} (include the surrounding quotes in the command).}

After a moment, you'll see a startup message like this:

@verbatim{
Welcome to Pollen 0.001 (Racket 6.x.x.x)
Project root is /path/to/tennyson
Project server is http://localhost:8080 (Ctrl-C to exit)
Project dashboard is http://localhost:8080/index.ptree
Ready to rock}

@italic{Project root} means the directory that the project server was started in, and which it's treating as its root directory. Any absolute URLs (i.e., those beginning with @litchar{/}) will resolve into this directory. So a URL like @racketfont{/styles.css} will impliedly become @racketfont{/path/to/tennyson/styles.css}. 

If you use the bare command @racketfont{raco pollen start}, the project server will start in the current directory. But if you want to start the project server elsewhere, you can add that directory as an argument like this:

@verbatim{
> raco pollen start /some/other/path
}

The next line of the startup message tells you that the web address of the project server is @racketfont{http://localhost:8080}. This is the address you put into your web browser to test your project. If you're unfamiliar with this style of URL, @racketfont{localhost} refers to your own machine, and @racketfont{8080} is the network port where the project server will respond to browser requests.

If you want to access the project server from a different machine, you obviously can't use @racketfont{localhost}. You can use the IP address of the machine running the project server (e.g., @racketfont{http://192.168.1.10:8080}) or any name for that machine available through local DNS (e.g., @racketfont{http://mb-laptop:8080}).

Though port @racketfont{8080} is the default, you can start the project server on any port you like by adding it as an argument to @racketfont{raco pollen start}:

@verbatim{
> raco pollen start /path/to/tennyson
> raco pollen start /path/to/tennyson 8088
}

@margin-note{You can also change the default port by altering @racket[world:default-port], or parameterizing it with @racket[world:current-server-port].}

Note that when you pass a port argument, you also have to pass a path argument. If you want to start in the current directory, you can use the usual @litchar{.} shorthand:

@verbatim{
> cd /path/to/tennyson
> raco pollen start 8088 
/path/to/tennyson/8088 is not a directory
> raco pollen start . 8088 
}

@margin-note{You can run multiple project servers simultaneously. Just start them on different ports so they don't conflict with each other.}

Your command-line window will report status and error messages from the project server as it runs. Use @onscreen{Ctrl-C} to stop the server. 


@subsection{Using the dashboard}

For each directory in your project, starting at the top, the project server displays a @italic{dashboard} in your web browser. The dashboard gives you an overview of the files in the directory, and links to easily view them.

The address of the top-level dashboard is @racketfont{http://localhost:8080/index.ptree}. Other dashboards follow the same pattern (e.g., @racketfont{http://localhost:8080/path/to/dir/index.ptree}.) 

Note that the dashboard is @bold{not} at @racketfont{http://localhost:8080/} or its equivalent, @racketfont{http://localhost:8080/index.html}. Why? So it doesn’t interfere with any @racketfont{index.html} that you may want to put in your project.

Thus, @racketfont{index.ptree}. The @racketfont{.ptree} extension is short for @italic{pagetree}. In Pollen, a pagetree is a hierarchical list of pages. We'll do more with pagetrees in a later tutorial. For now, just be aware that to generate the dashboard, the project server will first look for an actual @racketfont{index.ptree} file in each directory. If it doesn't find one, it will generate a pagetree from a listing of files in the directory.

Make sure your project server is running:

@verbatim{
> cd /path/to/tennyson
> raco pollen start
}

Then, in your web browser, visit @link["http://localhost:8080/index.ptree"]{@racketfont{http://localhost:8080/index.ptree}}. 

You should see something like this:

@image["dashboard.png" #:scale 1]

The top line tells us that we're in the root directory of the project. We didn't make an explicit @racketfont{index.ptree} file, so the project server just shows us a directory listing. 


@subsection{Source files in the dashboard}

We see the only file, @racketfont{poem.html.pp}. Note that the @racketfont{.pp} extension is grayed out. The dashboard automatically consolidates references to source and output files into a single entry. What this entry says is ``The directory contains a source file in @racketfont{.pp} format for the output file @racketfont{poem.html}.''

Every source-file entry in the dashboard has three links. The first link is attached to the filename itself, and takes you to a preview of the output file. If the output file doesn't yet exist — as is the case here — it will be dynamically rendered. (And this is true whether you click its name in the dashboard, or link to it from another page.) So click the filename and you'll see in your web browser:

@nested[#:style 'code-inset]{
"Ulysses" by Alfred Tennyson It little profits that an idle king, By this still hearth, ...} 

As a web page, this is pretty boring. The main point here is that you're seeing the @italic{output} from your source file, which didn't exist before. Notice that the address bar says @racketfont{http://localhost:8080/poem.html}, not @racketfont{poem.html.pp}. And if you go look in your @racketfont{tennyson} directory, you'll see a new file called @racketfont{poem.html}. 

In other words, when you clicked on the filename link in the dashboard, Pollen rendered the output file from your source file and saved it in your project directory. As promised earlier, the name of the output file (@racketfont{poem.html}) is the name of the source file (@racketfont{poem.html.pp}) minus the Pollen extension (@racketfont{.pp}).

If you go back to the dashboard and click on the filename link again, you'll see the same output file. If the source file hasn't changed, Pollen will just show you the output file that's already been rendered. But if you like, open your @racketfont{poem.html.pp} source file in DrRacket, edit the first line, and save the file:

@nested[#:style 'code-inset]{@verbatim{
#lang pollen

"Strawberry Fields" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}

Go back to the dashboard and click on the filename. This time, you'll see:

@nested[#:style 'code-inset]{
"Strawberry Fields" by Alfred Tennyson It little profits that an idle king, ...} 

Here, Pollen notices that the source file has changed and renders the output file again. This is convenient, as you can edit source in DrRacket, and reload the file in the project server to see the changes.

The other two links in the dashboard are probably self-explanatory. The link labeled @racketfont{in} will display the contents of the source file:

@nested[#:style 'code-inset]{@verbatim{
#lang pollen

"Strawberry Fields" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}

The link labeled @racketfont{out} will display the contents of the output file (just like the ``view source'' option in your web browser):

@nested[#:style 'code-inset]{@verbatim{
"Strawberry Fields" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}

For now, the files are identical except for the @racketfont{#lang} line. But let's change that.

@section{Working with the preprocessor}

Pollen can operate in several processing modes. One of these is @italic{preprocessor} mode.  A preprocessor is a tool for making systematic, automated changes to a file, often in contemplation of further processing (hence the @italic{pre-}). You can use the Pollen preprocessor this way. Or you can just use it on its own, and leave your files in a finished state. 

That's how we'll use it in this tutorial. We'll build out our @racketfont{poem.html.pp} source file so that it exits the preprocessor as a legit HTML file.

@subsection{Setting up a preprocessor source file}

The file extension of a Pollen source file tells Pollen what kind of processing to apply to it. The ``@racketfont{.pp}'' file extension stands for ``Pollen preprocessor.'' You can use the preprocessor with any text-based file by:
@itemlist[

@item{inserting @racketfont{#lang pollen} as the first line,}

@item{adding the @racketfont{.pp} file extension,}

@item{running it through Pollen.}
]

@margin-note{For more about the Pollen processing modes and how to invoke them, see @secref["file-types"].}

``The preprocessor be used with @bold{any} kind of text-based file?'' Right. ``But how?'' The preprocessor reads the source file, handles any Pollen commands it finds, and lets the rest of the content pass through untouched. To the preprocessor, it's all just text data. It doesn't care whether that text represents HTML, or CSS, or JavaScript, or @link["https://en.wikipedia.org/wiki/TI-BASIC"]{TI-BASIC}.

That means, however, that any Pollen commands you use in the preprocessor have to produce text for the result to make any sense. Moreover, Pollen doesn't enforce the semantics of the file — that's your responsibility. For instance, Pollen won't stop you from doing nonsensical things like this:

@filebox["bad-poem.html.pp"]{@verbatim{
#lang pollen

"Ulysses" by Alfred Tennyson

◊(insert-pdf-of-ulysses)
 }}

But the result is not going to be a valid HTML file. To paraphrase Mr. Babbage — garbage in, garbage out.

I've encouraged you to mess with the source file, but let's return it to its original state:

@filebox["/path/to/tennyson/poem.html.pp"]{@verbatim{
#lang pollen

"Ulysses" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}

This file has @racketfont{#lang pollen} as the first line, and @racketfont{.pp} as the file extension, so it meets the minimum requirements for the preprocessor.

@subsection{Creating valid HTML output}

We still have to update our source so it produces valid HTML. Edit the source as follows:

@filebox["/path/to/tennyson/poem.html.pp"]{@verbatim{
#lang pollen
<!DOCTYPE html>
<html>
<body>
<pre>
"Ulysses" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, 
...
</pre>
</body>
</html>}}

Return to the project server and view @link["http://localhost:8080/poem.html" "http://localhost:8080/poem.html"]. Earlier, the output looked like this:

@nested[#:style 'code-inset]{
"Ulysses" by Alfred Tennyson It little profits that an idle king, By this still hearth, ...} 

But now, because of the @racketfont{<pre>} tag, the poem will appear in a monospaced font, and the line breaks will be preserved:

@nested[#:style 'code-inset]{
@tt{"Ulysses" by Alfred Tennyson 
@(linebreak)
@(linebreak)It little profits that an idle king, 
@(linebreak)By this still hearth, among these barren crags,
@(linebreak)...}}

As before, because the source has changed, Pollen renders the file again. From the dashboard, you can use the @racketfont{in} and @racketfont{out} links to inspect the source and output. 

This is now a valid HTML page. But it's still boring. Let's fix that.

@subsection{Adding Pollen commands}









