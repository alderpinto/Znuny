# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::OutputFilterGoogleRecaptcha;

use Data::Dumper;

use strict;
use warnings;
use Kernel::System::Encode;
use Kernel::System::DB;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $WebSiteKey = $Kernel::OM->Get('Kernel::Config')->Get( 'GoogleCaptcha::SiteKey' ) || '';
    my $StringLogin = $LayoutObject->{LanguageObject}->Translate('Log In');
	my $StringSignup = $LayoutObject->{LanguageObject}->Translate('Create');

	my $Field = qq~
	<div class="recaptcha-holder"></div>
	~;

	my $FieldSignup = qq~
	<div class="NewLine">
	<div class="recaptcha-holder"></div>
	</div>
	~;	

	my $FormGRecaptcha = qq~
	<span id="FormGRecaptcha">
	<form action="" method="post">
	<div class="recaptcha-holder"></div>
	</form>
	</span>
	~;


	my $SearchSpanLogin = qr/(<span id="Login">)/mp;
	my $SearchFieldLogin = qr/(<div>\n\s*<button\stype="submit"\s*value="$StringLogin"\s*disabled="disabled">$StringLogin<\/button>)/mp;
	my $SearchFieldSignup = qr/(<div class="NewLine">\n\s*<button\sid="CreateAccount"\stype="submit"\s*value="$StringSignup"\s*disabled="disabled">$StringSignup<\/button>)/mp;

	#search and replace	 
	${ $Param{Data} } =~ s{$SearchSpanLogin}{$FormGRecaptcha $1}; 

	#search and replace	 
	${ $Param{Data} } =~ s{$SearchFieldSignup}{$FieldSignup $1};           

	#search and replace	 
	${ $Param{Data} } =~ s{$SearchFieldLogin}{$Field $1};   	

	####if ($Param{TemplateFile} eq 'Login'){
	####	my $button =''.
	####	'<div class="recaptcha-holder"></div>';
	####	${ $Param{Data} } =~ s{(</fieldset>)}{$button $1 }xms;
	####} else {
	####	my $button =''
	####	.'<div class="recaptcha-holder"></div>';
	####	${ $Param{Data} } =~ s{(</div>\n\s*<div\sid="Reset">)}{$button $1}xms;
	####}

	####my $Action = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Action' ) || "";

	####if($Action eq "Logout"){
	####	$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
	####		Name => 'Logout',
	####		Data => {
	####		},
	####	);
	####}
	
	my $Script = $LayoutObject->Output(
	    	 TemplateFile => 'OutputFilterGoogleRecaptcha',
		     Data         => {
				 GoogleSiteKey => $WebSiteKey
			 },
    	);

    ${ $Param{Data} } .= $Script;
    	
}
1;
