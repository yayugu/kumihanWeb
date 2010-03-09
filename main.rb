def makePDF(text)
  rndFile = "data/" + rand(100000000).to_s
  open(rndFile, "w"){|fp| fp.write(text)}
  puts rndFile
  IO.popen("perl pdf.pl #{rndFile}") do |io|
    puts io.read
  end
  rndFile + ".pdf"
end

post '/' do
  s = makePDF params[:mainText]
  return <<-EOF
<html>
<a href="#{s}">#{s}</a>
</html>
  EOF
end
