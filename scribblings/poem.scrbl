#lang scribble/manual

@title{First, a poem}

In this tutorial, you'll use Pollen to make a single HTML page with a poem. You'll learn about:

@itemlist[

@item{The preprocessor}

@item{The project server}

@item{Command syntax}

@item{DrRacket}

@item{Project structure}

@item{Using variables to store values}

]

Like many first tutorials, this one is designed for simplicity, and thus is also somewhat contrived. Once you get comfortable with Pollen, you're unlikely to make HTML pages this way. So if you consider yourself a quick study, feel free to skip ahead to the next tutorial. You can always come back.

@section{Prerequisites}

I'm going to assume that you've already installed Racket and Pollen. If not, do that now.

I'm also going to assume you know the basics of using a command line to run programs and navigate the file system using commands like @tt{cd} and @tt{ls}.


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

Note that the language is now reported as @racketfont{pollen}. If you like, change the @racketfont{#lang} line to this, and then @onscreen["Run"] again:

@racketmod[pollenxyz]

DrRacket will print an error in the interactions window that looks like:

@verbatim{@racketerror{Module Language: invalid module text
@(linebreak)standard-module-name-resolver: collection not found ...}}

Because there's no language called @racketfont{pollenxyz}.

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

This shows you something important: by default, any plain text in a Pollen source file is simply printed as written when you @onscreen["Run"] the file (minus the @racketfont{#lang} line, which is not part of the output). If you like, edit the text of the poem and click @onscreen["Run"] again. You'll see the updated text printed in the interactions window.

@subsection{Saving the file}

File naming in Pollen is consequential. Ultimately, every Pollen source file in your project will be @italic{rendered} into an output file. Each Pollen source file corresponds to one output file. The name of this output file will be the name of the source file minus the Pollen file extension of the source file. So a source file called @racketfont{file.txt.pp} will become @racketfont{file.txt}.

Therefore, to derive the name of a source file, we take the desired name of the output file and add the appropriate Pollen file extension. There's more than one Pollen file extension — but we'll cover that later. For now, the extension you'll use for your source is @racketfont{.pp}.

In this case, let's say we want to end up with a file called @racketfont{poem.html}. Therefore, the name of our source file needs to be @racketfont{poem.html} plus the file extension @racketfont{.pp} = @racketfont{poem.html.pp}. (If you want to name the file @racketfont{something-else.html.pp}, be my guest. There's no magic associated with the prefix.)

So in a convenient location (like your desktop), save your DrRacket file as @racketfont{poem.html.pp}.

@filebox["poem.html.pp"]{@verbatim{
#lang pollen

"Ulysses" by Alfred Tennyson
 
It little profits that an idle king,
By this still hearth, among these barren crags, ...}}

