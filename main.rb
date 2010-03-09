def makePDF(text)
  rndFile = "data/" + (Time.now.to_f*1000000).to_i.to_s
  open("public/" + rndFile, "w"){|fp| fp.write(text)}
  IO.popen("perl pdf.pl public/#{rndFile}") do |io|
    puts io.read
  end
  rndFile + ".pdf"
end

post '/make' do
  s = makePDF params[:mainText]
  return <<-EOF
<html>
<a href="#{s}">#{s}</a>
</html>
  EOF
end
