package match::simple;

use 5.008001;
use strict;
use warnings;

use List::MoreUtils qw(any);
use Scalar::Util qw(blessed);
use Sub::Infix qw(infix);

BEGIN {
	$match::simple::AUTHORITY = 'cpan:TOBYINK';
	$match::simple::VERSION   = '0.002';
}

use base "Exporter::TypeTiny";
our @EXPORT    = qw( M );
our @EXPORT_OK = qw( match );

sub match
{
	no warnings qw(uninitialized numeric);
	
	my ($a, $b) = @_;
	
	return(!defined $a)                    if !defined($b);
	return($a eq $b)                       if !ref($b);
	return($a =~ $b)                       if ref($b) eq q(Regexp);
	return do{ local $_ = $a; !!$b->($a) } if ref($b) eq q(CODE);
	return any { match($a, $_) } @$b       if ref($b) eq q(ARRAY);
	return !!$b->check($a)                 if blessed($b) && $b->isa("Type::Tiny");
	return !!$b->MATCH($a)                 if blessed($b) && $b->can("MATCH");
	return eval 'no warnings; !!($a~~$b)'  if blessed($b) && $] >= 5.010 && do { require overload; overload::Method($b, "~~") };
	
	require Carp;
	Carp::croak("match::simple cannot match anything against: $b");
}

*M = &infix(\&match);

__END__

=pod

=encoding utf-8

=for stopwords smartmatch recurses

=head1 NAME

match::simple - simplified clone of smartmatch operator

=head1 SYNOPSIS

   use v5.10;
   use match::simple;
   
   if ($this |M| $that)
   {
      say "$this matches $that";
   }

=head1 DESCRIPTION

match::simple provides a simple match operator C<< |M| >> that acts like
a sane subset of the (as of Perl 5.18) deprecated smart match operator.
Unlike smart match, the behaviour of the match is determined entirely by
the operand on the right hand side.

=over

=item *

If the right hand side is C<undef>, then there is only a match if the left
hand side is also C<undef>.

=item *

If the right hand side is a non-reference, then the match is a simple string
match.

=item *

If the right hand side is a reference to a regexp, then the left hand is
evaluated .

=item *

If the right hand side is a code reference, then it is called in a boolean
context with the left hand side being passed as an argument.

=item *

If the right hand side is an object which provides a C<MATCH> method, then
it this is called as a method, with the left hand side being passed as an
argument.

=item *

If the right hand side is an object which overloads C<~~>, then a true
smart match is performed.

=item *

If the right hand side is an arrayref, then the operator recurses into the
array, with the match succeeding if the left hand side matches any array
element.

=item *

If any other value appears on the right hand side, the operator will croak.

=back

If you don't like the crazy C<Sub::Infix> operator, you can alternatively
export a more normal function:

   use v5.10;
   use match::simple qw(match);
   
   if (match($this, $that))
   {
      say "$this matches $that";
   }

=begin trustme

=item M

=item match

=end trustme

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=match-simple>.

=head1 SEE ALSO

L<match::smart>.

This module uses L<Exporter::TypeTiny>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

