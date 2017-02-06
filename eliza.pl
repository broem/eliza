#!C:/Strawberry/perl -w

#eliza.pl
#Benjamin Leach
#CMSC



my $eliza = '[Eliza]';
my $user = 'Criminal';
my @self = ('i', 'i am', 'me', 'my');
my @happy = ('happy', 'glad', 'joy');
my @sad = ('sad', 'upset', 'depressed', 'anxious');
# ok should be a special case?
my @anger = ('angry', 'mad'); 
my @random = ('hungry');
my @sorry = ('sorry', 'apologize');
my $annoyance = 0;
my $crimNum = 1000 + int rand(999);
sub rmwhite { my $i = shift; $i=~s/^\s*(.*?)\s*$/$1/; return $i};

print $eliza." Welcome patient I'm Eliza, your court appointed psychotherapist.\n";
sleep (2);
print $eliza." Let me make sure I've got your name right, what was it again? \n";

print "[$user$crimNum] ";
$user = <>;
#print "\n";

sleep (1);

$user =  ucfirst(lc $user);
chomp $user;
print $eliza." Oh great, it's you again, wonderful.\n";
sleep (1);
print "$eliza Ok $user how can the state help you today?\n";

while(1){
	print "[$user] ";
	my $randomNum = 1 + int rand(10); #random number for automated responses
	my $input = "";
	$input = <>;
	my $additional="";
	my $notFound = 1; 		# if no match default response
	my $changeBypass = 1; 	# when there is a preloaded response that has a key word, this will bypass
	my $noQmark = 1;

	
	chomp $input;
	$input = rmwhite($input); 		#remove the trailing and preceeding whitespace
	
	$input = lc $input;		# easier to work with lowercase
	
	my $len = length($input);

	# remove and replace Pronouns to change later
	$input=~s/\byou are\b/bleach5/g;
	$input=~s/\byou\b/bleach1/g;
	$input=~s/\byour\b/bleach2/g;
	$input=~s/\byours\b/bleach3/g;
	$input=~s/\byourself\b/bleach4/g;


	if($input=~m/\beliza\b/) {
		$changeBypass = 0;
		$notFound = 0;
		if($randomNum < 3) {
			$input="We're not here to discuss me, got it";
		}
		if($randomNum >= 3 and $randomNum <= 6) {
			$noQmark = 0;
			$input="This is a place to talk about yourself, let's keep it that way."
		}
		if($randomNum > 6) {
			$input="Listen, last time I checked I wasn't the one in need of a psyc, don't talk about me."
		}
	}

	$input=~s/[.?!]//;
	#remove some beginning colloquial things
	if($len > 5) {
	$input=~s/^(\bok\b|\byeah\b|\byes\b|\bno\b|\bwell\b)//g;
	}

	if(length($input) > 45) {
		$input = "I do not get paid to read these long diatribes, let's keep it short ok";
		$notFound = 0;
		$changeBypass = 0;
	}

	if($input=~m/\bguess\b/g){
		$input = "you guess";
		$notFound = 0;
		$changeBypass = 0;
	}

	if($input=~m/sorry|apologize/ and $changeBypass == 1) {
		$notFound = 0;
		$changeBypass = 0;
		$noQmark = 0;
		$input = "Don't apologize. Continue.";
	}

	# why dont we start from the beginning

	# make eliza so unhappy she quits
	if($input=~m/^(\byes\b|\bno\b|\bnope\b|\byep\b|\byeah\b)$/ and $changeBypass == 1){
		$notFound = 0;
		if($randomNum <= 5 and $annoyance < 3) {
			$input= "...could you elaborate"; 
			$annoyance++;}
		if($randomNum > 5 and $annoyance < 3) {
			$input= "can you please explain yourself";
			$annoyance++;}
		if($annoyance >= 5) {
			print "Ok this session is over! Enjoy your prison stay.";
			last;
		}
		if($annoyance >= 3) {
			$input= "can you stop with the one word answers";
			$annoyance++;
		}
	}


	# Pronoun section 
	if($changeBypass == 1) {

		if($input=~m/\b(i am)\b|\b(im)\b|\b(i'm)\b/g) {
			$notFound = 0;
			$input=~s/$&/you're/g;
		}

		if($input=~m/\bmy\b/) {
			$notFound = 0;
			$input=~s/$&/your/g;
		}
		
		if($input=~m/(\bi\b|\bme\b)/g) {
			$notFound = 0;
			$input=~s/\b$&\b/you/g;
		}

		if($input=~m/\bmyself\b/) {
			$notFound = 0;
			$input=~s/\b$&\b/yourself/g;
		}

		# replacing the ones removed earlier
		if($input=~m/bleach/) {
			$input=~s/\bbleach5\b/I am/g;
			$input=~s/\bbleach1\b/I/g;
			$input=~s/\bbleach2\b/my/g;
			$input=~s/\bbleach3\b/mine/g;
			$input=~s/\bbleach4\b/myself/g;
			$notFound = 0;
		}

	}
	# end of section

	if($input=~m/\bleave\b|\bquit\b|\b"end this"\b/) {
		$additional = "If you want to leave just say quit.";
	}

	if($input=~m/^(hm+)$/) {
		$noQmark = 0;
		$input = "My time is valuable, don't waste it.";
	}

	if($input=~m/^\bbecause\b/ and $changeBypass == 1){
		$input=~s/$&//g;
	}

	if($input=~m/\bfeel\b/g){
		$notFound = 0;
		$input = "Why do you think you feel this way";
	}

	# remove yes and ok
	if($input=~m/\b(yes|ok)\b/g and $changeBypass == 1){
		$notFound = 0;
		$input=~s/$&//;
	}

	# happy line of questioning
	if($input=~m/\bhappy\b|\bglad\b|\bjoyful\b/){
		$additional = "Whoopty doo! What else?";
		$notFound = 0;
	}

	if($input=~m/\bangry\b|\bsad\b|\bupset\b|\bdepressed\b|\banxious\b/) {
		$notFound = 0;
		$input= "its ok to be $&, tell me more.";
	}

	if($input=~m/\bhelp\b/) {
		$notFound = 0;
		$input = "ok...what do you think I can do";
	}

	if($input=~m/\+|\-|\=|\*/) {
		$noQmark = 0;
		$notFound = 0;
		$input = "If this is math, I'm not a calculator. Act responsibly or I WILL cut your time short!";
	}

	if($input=~m/^quit$/){
		#sleep(2);
		print "$eliza Finally! I don't get paid enough for this, bye.";
		last;
	}

	#if doesnt ultimately understand
	if($notFound == 1){
		$said = $input;
		$noQmark = 0;
		if($randomNum < 3) {
			$input="I don't know what $said means, explain.";
		}
		if($randomNum > 3 and $randomNum < 6) {
			$input="I'm not following you, can you explain differently.";
		}
		if($randomNum >= 6){
			$input="English is not my first language, reword that.";
		}

		#$input="I think you're meds are wearing off...can you try again"
	}
	# things to remove: because, 
	#i dont get paid enough to play these games

	

	$input = rmwhite($input);
	if($input eq ""){
		$input = "well";
	}



	$input = ucfirst $input;
	if($noQmark == 1) {
		$input .= "?"
	}
	#sleep(2);
	print "$eliza $input $additional\n";
}


