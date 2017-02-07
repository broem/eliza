#!C:\Strawberry\perl\bin -w

#eliza.pl
#Benjamin Leach
#CMSC-416

#NOTE: my linux machine died, my windows machine cannot run a VM, I assume the 
#above include is correct. 


# Sample input:
#[Eliza] Welcome patient I'm Eliza, your court appointed psychotherapist.
#[Eliza] Let me make sure I've got your name right, what was it again?
#[Criminal1489] ben
#[Eliza] Oh great, it's you again, wonderful.
#[Eliza] Ok Ben how can the state help you today?
#[Ben] i want out
#[Eliza] You want out?
#[Ben] this place is scary
#[Eliza] Wow, you don't say, go on...
#[Ben] everyone here is mean
#[Eliza] That's almost interesting, tell me a bit more.
#[Ben] fugjk
#[Eliza] I don't know what fugjk means, explain.
#...
#[Ben] how do i leave this place?
#[Eliza] Leave? If you want to leave just say quit.
#[Ben] QUIT!
#[Eliza] Finally! I don't get paid enough for this, bye.



my $eliza = '[Eliza]';
my $user = 'Criminal';
my $prev = "";
my $annoyance = 0;
my $crimNum = 1000 + int rand(999);

# removes whitespace
sub rmwhite { my $i = shift; $i=~s/^\s*(.*?)\s*$/$1/; return $i}; # the shift here takes in the first argument it was passed 

print $eliza." Welcome patient I'm Eliza, your court appointed psychotherapist.\n";
sleep (2);
print $eliza." Let me make sure I've got your name right, what was it again? \n";

print "[$user$crimNum] ";
$user = <>;


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
	my $skip = 1; 			# skips everyting
	
	chomp $input;
	$input = rmwhite($input); 		#remove the trailing and preceeding whitespace
	
	$input = lc $input;		# easier to work with lowercase
	
	my $len = length($input);

	# check for repitition 
	if($prev eq $input) {
		$skip = 0;
	}

	$prev = $input;

	# remove and replace Pronouns to change later
	$input=~s/\byou are\b/bleach5/g;
	$input=~s/\byou\b/bleach1/g;
	$input=~s/\byour\b/bleach2/g;
	$input=~s/\byours\b/bleach3/g;
	$input=~s/\byourself\b/bleach4/g;

	$input=~s/[.?!]//;

	#remove some beginning things
	if($len > 5) {
	$input=~s/^(\bok\b|\byeah\b|\byes\b|\bno\b|\bwell\b)//g;
	}

	# typing long sentences for a stressed psych
	if(length($input) > 45) {
		$input = "I do not get paid to read these long diatribes, let's keep it short ok?";
		$notFound = 0;
		$changeBypass = 0;
	}

	# dont talk about eliza
	if($input=~m/\beliza\b/) {
		$changeBypass = 0;
		$notFound = 0;
		$annoyance++;
		if($randomNum < 3) {
			$input="We're not here to discuss me, got it";
		}
		if($randomNum >= 3 and $randomNum <= 6) {
			$noQmark = 0;
			$input="This is a place to talk about yourself, let's keep it that way."
		}
		if($randomNum > 6 or $annoyance > 3) {
			$noQmark = 0;
			$input="Listen, don't talk about me."
		}
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
		$annoyance--;
		$input = "Don't apologize. Continue.";
	}

	# make eliza so unhappy she quits
	if($input=~m/^(\byes\b|\bno\b|\bnope\b|\byep\b|\byeah\b|\bsure\b)$/ and $changeBypass == 1){
		$notFound = 0;
		if($randomNum <= 5 and $annoyance < 3) {
			$input= "...could you elaborate"; 
			$annoyance++;}
		if($randomNum > 5 and $annoyance < 3) {
			$input= "can you please explain yourself";
			$annoyance++;}
		if($annoyance >= 5) {
			sleep(3);
			print "You are so annoying! This session is over! Enjoy your prison stay, scum.";
			last;
		}
		if($annoyance >= 3) {
			$input= "can you stop with the one word answers";
			$annoyance++;
		}
	}


	# Pronoun section 
	if($changeBypass == 1) {

		if($input=~m/\b(i am)\b|\bim\b|\b(i'm)\b/g) {
			$notFound = 0;
			$input=~s/\b$&\b/you're/g;
		}

		if($input=~m/\bmy\b/) {
			$notFound = 0;
			$input=~s/\b$&\b/your/g;
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

	# restructure for wants and needs
	my $part = "why do you think you";
	
	$input=~s/(.*)\bcan\b(.*)/$part can$2/;
	$input=~s/(.*)\bwant\b(.*)/$part want$2/;
	$input=~s/(.*)\bneed\b(.*)/$part need$2/;
	#$input=~s/(.*)\bcan't\b(.*)/why do you think you can't$2/;
	$input=~s/(.*)\bmust\b(.*)/$part must$2/;

	# getting the wishes and desires in
	if($input=~m/\bcrave(s)?\b|desire|wish|hunger|thirst|greed|appetite|lust|ache|yearn|hope/){
		$input = "well, lets discuss this \"$&\"";
	}


	if($input=~m/\bleave\b|\bquit\b|\b"end this"\b/) {
		$annoyance--; # shes a little less annoyed by you wanting to leave
		$notFound = 0;
		$input = $&;
		$additional = "If you want to leave just say quit.";
	}

	# eliza likes to get to the point hmms are not permitted
	if($input=~m/^hm+$/) {
		$noQmark = 0;
		$notFound = 0;
		$input = "My time is valuable, don't waste it.";
	}

	# remove at beginning 
	if($input=~m/^\bbecause\b/ and $changeBypass == 1){
		$input=~s/$&//g;
	}

	# generic feels get a generic response
	if($input=~m/\bfeel\b/g){
		$notFound = 0;
		$input = "Why do you think you feel this way";
	}

	# remove yes and ok
	if($input=~m/\b(yes|ok|yeah|yep)\b/g and $changeBypass == 1){
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
		$noQmark = 0;
		$input= "tell me more..."; # eliza says this a lot
	}

	if($input=~m/\bhelp\b/) {
		$notFound = 0;
		$input = "ok...what do you think I can do";
	}

	if($input=~m/\+|\-|\=|\*/) {
		$noQmark = 0;
		$notFound = 0;
		$annoyance++;
		$input = "I'm not a calculator. Act responsibly or I WILL cut your time short!";
	}

	if($input=~m/^quit$/){
		sleep(2);
		print "$eliza Finally! I don't get paid enough for this, bye.";
		last;
	}

	# some common words should get a response, can run into trouble here
	if($input=~m/he|she|they|boyfriend|girlfriend|mom|dad|mother|father|this|that|thing|world|very/g and $notFound == 1) {
		$notFound = 0;
		$noQmark = 0;
		
		if($randomNum < 2) {
			$input = "That's almost interesting, tell me a bit more.";
		}

		if($randomNum >=2 and $randomNum < 4) {
			$input = "neato, go on if you must.";
		}

		if($randomNum <= 6 and $randomNum >=4) {
			$input = "...ok. Go on.";
		}

		if($randomNum > 6) {
			$input = "wow, you don't say, go on...";
		}
	}

	# if doesnt ultimately understand
	if($notFound == 1){
		$said = $input;
		$noQmark = 0;

		if($randomNum < 3) {
			$input="I don't know what $said means, explain.";
		}
		if($randomNum > 3 and $randomNum < 6) {
			$input="I'm not following you, can you explain differently.";
		}
		if($randomNum > 6){
			$input="English is not my first language, reword that.";
		}
		if($randomNum == 6) {
			$input="I think you're meds are wearing off...can you try again?"
		}
	}

	# remove whitespace at end incase left with nothing
	$input = rmwhite($input);
	if($input eq ""){
		$input = "well";
	}

	if($noQmark == 1) {
		$input .= "?"
	}

	if($skip == 0) {
		$input = "I saw you the first time. Don't repeat youself!";
	}

	$input = ucfirst $input;
	
	sleep(2);
	print "$eliza $input $additional\n";
}


