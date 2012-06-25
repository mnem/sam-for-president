require 'sinatra'
require 'nokogiri'

$stdout.sync = true

UA = [
  'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.14 (KHTML, like Gecko) Chrome/10.0.601.0 Safari/534.14',
  'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.20 (KHTML, like Gecko) Chrome/11.0.672.2 Safari/534.20',
  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.27 (KHTML, like Gecko) Chrome/12.0.712.0 Safari/534.27',
  'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.24 Safari/535.1',
  'Mozilla/5.0 (Windows; U; Windows NT 5.1; tr; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 ( .NET CLR 3.5.30729; .NET4.0E)',
  'Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1',
  'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:2.0.1) Gecko/20100101 Firefox/4.0.1',
  'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0',
  'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0a2) Gecko/20110622 Firefox/6.0a2',
  'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1',
  'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/5.0)',
  'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)',
  'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.2; Trident/5.0)',
  'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.2; WOW64; Trident/5.0)',
  'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.15 Safari/534.13',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20100101 Firefox/9.0',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2; rv:10.0.1) Gecko/20100101 Firefox/10.0.1',
  'Mozilla/5.0 (iPad; U; CPU OS 4_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F190 Safari/6533.18.5',
  'Mozilla/5.0 (iPad; U; CPU OS 4_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F190 Safari/6533.18.5',
  'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; da-dk) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5',
  'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3 like Mac OS X; de-de) AppleWebKit/533.17.9 (KHTML, like Gecko) Mobile/8F190'
]

SAM_REFERERS = [
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  "https://twitter.com/kaeladan/status/216166384982437889",
  'https://www.facebook.com/kaeladan',
  'https://www.facebook.com/kaeladan',
  'https://www.facebook.com/kaeladan'
]

PAGE_REFERERS = [
  "https://twitter.com/",
  "https://twitter.com/",
  "https://twitter.com/",
  "https://twitter.com/",
  "https://twitter.com/",
  "https://twitter.com/",
  "https://twitter.com/",
  "https://twitter.com/",
  'https://www.facebook.com/',
  'https://www.facebook.com/'
]

RATING = [
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '4',
  '5',
  '5',
  '5',
  '5',
  '5'
]

VOTE_PAGE = 'http://www.takeyourdog.com/Gallery/photo-detail/'
VOTE_API = 'http://www.takeyourdog.com/Gallery/filerating.php'

def show_result(result)
  begin
    doc = Nokogiri.XML result
    status = doc.xpath('//status').first.content
    message = doc.xpath('//message').first.content
    votes = doc.xpath('//total_votes').first.content
    $last_know_votes = Integer(votes)
    rating = doc.xpath('//rating').first.content
    if status == '0'
      "Votes: #{votes}, rating: #{rating}"
    else
      "OH NOES! The server said '#{message}'"
    end
  rescue Exception => e
    "Can't parse result: #{result}"
  end
end

def vote(id, ua, rating, referrer)
  vote_page = "#{VOTE_PAGE}#{id}"
  # 'Visit' the voting page from somewhere
  %x[curl -s --referer #{referrer}  --user-agent '#{ua}' #{vote_page}]
  # Look at the page for a bit
  sleepy_time = 1 + (5 * rand)
  sleep sleepy_time
  # Hit the vote link
  %x[curl -s --referer #{vote_page}  --user-agent '#{ua}' --data 'file_id=#{id}&rating=#{rating}' #{VOTE_API}]
end

##############################################################################
# Routes
get '/' do
  "Hello, world"
end

SAM_ID = '2102'

get '/vote-sam' do
  show_result vote SAM_ID, UA.sample, RATING.sample, SAM_REFERERS.sample
end

get '/vote/:id' do |id|
  if id == SAM_ID
    referrer = SAM_REFERERS.sample
  else
    referrer = PAGE_REFERERS.sample
  end
  show_result vote id, UA.sample, RATING.sample, referrer
end
