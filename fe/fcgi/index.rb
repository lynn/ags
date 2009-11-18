require 'handler'

class Index < Handler
  def handle_
    html_header
    title("anarchy golf")

    puts %Q(<h1>Anarchy Golf</h1>
<p>
This is a golf server.
You can enjoy short coding here in several languages (#{file_types.size} languages).
The purpose of this server is not serious competition.
Joke problems are welcomed and
you can speak freely about problems and can release spoilers.
For serious competition with ranking,
enter <a href="http://codegolf.com/">Code Golf</a>.
</p>
<p>
IRC channel for this golf server: #anagol in freenode. Please feel free to join the channel to talk about various things around golf.
</p>
<p>
Mark Byers kindly prepared a <a href="http://sites.google.com/site/codegolfingtips/Home">site</a> for this golf server. If you would like to join to add tips, please ask Mark to add you as a collaborator (supposedly, in IRC?).
</p>

<p style="color: red;">
The server is upgraded. There should be some issues (as usual!).
Please let me know (at shinichiro.hamaji _at_ gmail.com) if you found an issue.
</p>

)

    if @e['SERVER_NAME'] != 'golf.shinh.org'
      puts %Q(This URI will be deprecated. Please use new URI: <a href="http://golf.shinh.org/">http://golf.shinh.org/</a>)
    end

    pdb = problem_db
    problems = pdb.get('root')
    deadlines = pdb.get('deadline')
    active_problems = []
    hot_post_mortems = []
    now = Time.now.to_i
    problems.zip(deadlines, [*1..deadlines.size]).each do |p, d, i|
      if d && d > now
        active_problems << [d, p, i]
      elsif d && d < now && d > now - 60 * 60 * 24 * 14
        hot_post_mortems << [d, p, i]
      end
    end

    if !active_problems.empty?
      puts '<h2>Active problems</h2><ul>'
      active_problems.sort_by{|d,x,i|[d,i,x]}.each do |d, x, i|
        puts tag('li',
                 "#{i}. " + a(problem_url(x), x) +
                 " #{time_diff(d-now)} left (#{Time.at(d).strftime('%m/%d %H:%M:%S JST')})")
      end
      puts '</ul>'
    end

    if !hot_post_mortems.empty?
      puts '<h2>Hot post mortems</h2><ul>'
      hot_post_mortems.sort_by{|d,x,i|-d}.each do |d, x, i|
        puts tag('li',
                 "#{i}. " + a(problem_url(x), x) +
                 " #{time_diff(now-d)} before")
      end
      puts '</ul>'
    end

    puts '<h2>All problems</h2>'

    puts '<ol>'
    problems.each do |x|
      puts tag('li', a(problem_url(x), x))
    end
    puts '</ol>'

    puts a("mkprob.html", "create new problem")
    puts '<br>'
    puts a("recent.rb", "recent records")
    puts '<br>'
    puts a("lranking.rb", "language ranking")
    puts '<br>'
    puts a("checker.html", "performance checker")
    puts '<br>'
    puts a("http://github.com/shinh/caddy", "caddy, a testing/squeezing/submission helper tool for golfers")
    puts '<br>'

    puts %Q(
<p>
News
<ul>
<li>Now, the golf server was upgraded. The new system should be faster than before.
<pre>
Ubuntu hardy => Debian squeeze (with sid packages)
linux-2.6.19-4 => linux-2.6.26-2
Mobile Intel(R) Celeron(R) CPU 1.70GHz => Intel(R) Core(TM)2 CPU T5600 @ 1.83GHz
384MB/128MB => 1GB/256MB (web server / execution server)
</pre>
Many languages were upgrade. I'll work on gathering the version information of them.
<li>Some submissions were gone due to disk full. I'm sorry about this. Please re-post your code again.
<li>added <a href="http://golang.org/">Go</a>.
<li>Now the execution server removes written files and directories using tmpfs. Please tell me if you can create a file and utilize the file content by another submission. Also, I removed some records in "hello world" problem as I guess they used file creation. If you didn't, please re-submit the code.
<li>created <a href="http://golf.shinh.org/lang_speed.html">a graph which shows the best solutions size and speed</a>, inspired by <a href="http://shootout.alioth.debian.org/u32/shapes.php">Computer Language Benchmarks Game</a>. <a href="http://golf.shinh.org/lang_speed2.html">Another graph</a> whose size is shown by score (10000 * size_of_best_lang / size_of_the_lang).
<li>added <a href="http://arclanguage.com/install">Arc</a>. Thanks flagitious for suggestion and <a href="http://route477.net/d/?date=20090929#p01">yhara</a> for investigating how to run it in this system.
<li>To support OCaml golf competition, OCaml will be in the top of the language lists for a while.
<li>added <a href="http://asymptote.sourceforge.net/">Asymptote</a> (thanks notogawa for suggestion!).
<li>added <a href="http://maxima.sourceforge.net/">Maxima</a> (thanks yshl!) and <a href="http://rebol.com/">REBOL</a> (thanks Jos\'h!). I couldn\'t find the best suffixes for them. I couldn\'t find commonly used suffix for Maxima. REBOL\'s "r" was already used by R. If you know better suffixes for them, please let me know.
<li>added <a href="http://www.ueda.info.waseda.ac.jp/lmntal/pukiwiki.php?LMNtal">LMNtal</a>.
<li>I forgot to mention this... There is a twitter account which reports the recent activities: http://twitter.com/mircbot. You may able to use its RSS as well.
<li>updated the interpreter of Universal Lambda. See <a href="http://www.golfscript.com/lam/">the official site</a> for the information how this changed. Also, added disassembled view of Universal Lambda. See <a href="http://golf.shinh.org/reveal.rb?Permutations/irori/1226857691&lamb">this code</a> for example.
<li>added <a href="http://www.golfscript.com/lam/">Universal Lambda</a>. Thanks flagitious!
<li>added <a href="http://www.geocities.jp/takt0_h/cyan/index.html">Cyan</a> (sorry, there seem to be no English docs).
<li>added Nemerle 0.9.3, <a href="http://tph.tuwien.ac.at/~oemer/qcl.html">QCL</a> 0.6.3 with <a href="http://shinh.skr.jp/dat_dir/qcl-0.6.3.patch">this patch</a>, and <a href="http://www.kite-language.org/trac">Kite</a> 1.0b6.
<li>added DOS using dosemu.
<li>now grass interpreter is <a href="http://panathenaia.halfmoon.jp/alang/grass.ml">OCaml version</a>. Thanks YT!
<li>submission size limit (CONTENT_LENGTH) was relaxed from 10k to 20k.
<li>added <a href="http://www.blue.sky.or.jp/grass/">Grass</a>. Now we are using <a href="http://www.blue.sky.or.jp/grass/grass.rb">grass.rb</a>. If you want to use faster implementation, please recommend me better implementations.
<li>ruby 1.8.7.
<li>allow more time for R (you have 2 sec for 3 test cases problems, 2.5 secs for 2 test cases, and 4 secs for 1 test case) since its invocation seems to take more than one second.
<li>updated execution server (Ubuntu edgy => gutsy). Many languages are updated (the detail will be described). Maybe now you can use standard input from /dev/fd/0. As usual :\(, there may be several bugs. Please report me if you find bugs.
</ul>
</p>
<p>
<a href="http://github.com/shinh/ags">Source code</a>.
<a href="langs.html">Version informations</a> (too old information!).
</p>
<p>
Contact: shinichiro.hamaji _at_ gmail.com .
If you found some bugs or you have some requests (fix problem you submitted, add language XXX, and etc.), please email me.
</p>
)

    foot
  end
end
