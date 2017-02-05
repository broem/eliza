#!C:/Strawberry/perl -w

#eliza.pl
#Benjamin Leach
#CMSC



my $eliza = '[Eliza]';
my $user = '[Criminal34532]';
my @self = ('i', 'i am', 'me', 'my');
my @happy = ('happy', 'glad', 'joy');
my @sad = ('sad', 'upset', 'depressed', 'anxious');
# ok should be a special case?
my @anger = ('angry', 'mad'); 
my @random = ('hungry');
my @sorry = ('sorry', 'apologize');
my $annoyance = 0;
sub rmwhite { my $i = shift; $i=~s/^\s*(.*?)\s*$/$1/; return $i};

print $eliza." Welcome patient I'm Eliza, your court appointed psychotherapist.\n";
sleep (2);
print $eliza." Let me make sure I've got your name right, what was it again? \n";

print "$user ";
$user = <>;
#print "\n";

sleep (1);

$user =  ucfirst(lc $user);
chomp $user;
print $eliza." Oh great, it's you, wonderful.\n";
sleep (1);
print "$eliza Ok $user how can the state help you today?\n";

while(1){
	print "[$user] ";
	my $randomNum = 1 + int rand(10); #random number for automated responses
	my $input = <>;
	my $additional="";
	my $bool=1;
	my $changed=1;
	chomp $input;
	$input = rmwhite($input);
	#remove the trailing and preceeding whitespace
	$input = lc $input;

	if($input=~m/^please eliza, kind and benevolent overlord, dismiss me?$/){
		print "$eliza I'm glad to see you recognize my greatness, farewell.";
		last;
	}

	$input=~s/[.?!]//;
	#remove some colloquial things
	$input=~s/^(\bok\b|\byeah\b|\byes\b|\bno\b|\bwell\b)//;
	$tes = length($input);
	print("$tes\n");

	# if(length($input) ge 40) {
	# 	$input = "Either you shorten your sentences or I'm leaving.\n I do not get paid to read these long diatribes.";
	# 	$bool = 0;
	# 	$changed = 0;
	# }

	if($input=~m/sorry|apologize/ and $changed eq 1) {
		$bool = 0;
		$input = "No need to apologize. Can you continue";
	}

	#why dont we start from the beginning

	#make eliza so unhappy she quits!
	if($input=~m/^(\byes\b|\bno\b|\bnope\b|\byep\b|\byeah\b)$/ and $changed eq 1){
		$bool = 0;
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

	if($input=~m/\b(i am)\b|\b(im)\b|\b(i'm)\b/g and $changed eq 1) {
		$bool = 0;
		$input=~s/$&/you're/g;
	}
	
	if($input=~m/(\bi\b|\bme\b|\bmy\b)/g and $changed eq 1){
		$bool = 0;
		$input=~s/\b$&\b/you/g;
	}

	if($input=~m/\bbecause\b/ and $changed eq 1){
		$input=~s/$&//g;
	}

	if($input=~m/\bfeel\b/g){
		$bool = 0;
		$input = "Why do you think you feel this way";
	}

	if($input=~m/\b(yes|ok)\b/g and $changed eq 1){
		$bool = 0;
		$input=~s/$&//;
	}

	#happy line of questioning
	if($input=~m/\bhappy\b|\bglad\b|\bjoyful\b/){
		$input = "Atleast someone is $& to be here, can we move on";
		$bool = 0;
	}

	if($input=~m/\bangry\b|\bsad\b|\bupset\b|\bdepressed\b|\banxious\b/) {
		$input= "its ok to be $&, why do you think you are";
	}

	if($input=~m/\bhelp\b/) {
		$input = "ok...what do you think I can do";
	}

	if($input=~m/^quit$/){
		print "$eliza Finally! I don't get paid enough for this, bye.";
		last;
	}


	if($bool eq 1 ){
		#if doesnt ultimately understand
		$said = $input;
		$input="I don't know what $said means, explain";
		#$input="I think you're meds are wearing off...can you try again"
	}
	# things to remove: because, 
	#i dont get paid enough to play these games

	$input = rmwhite($input);
	$input = ucfirst $input;
	if($input ne "")
	{
		$input .= "?"
	}
	print "$eliza $input $additional\n";
}


