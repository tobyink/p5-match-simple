=pod

=encoding utf-8

=head1 PURPOSE

Test that match::simple works.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=cut

use strict;
use warnings;
use Test::More;

use match::simple;

sub does_match {
	my ($a, $b, $name) = @_;
	ok(
		$a |M| $b,
		$name,
	);
}

sub doesnt_match {
	my ($a, $b, $name) = @_;
	ok(
		!($a |M| $b),
		$name,
	);
}

does_match(undef, undef, 'undef |M| undef');
doesnt_match(q(), undef, 'NOT q() |M| undef');
does_match(q(xxx), q(xxx), 'q(xxx) |M| q(xxx)');
doesnt_match(q(xxx), q(yyy), 'NOT q(xxx) |M| q(yyy)');
does_match(q(xxx), qr(xxx), 'q(xxx) |M| qr(xxx)');
doesnt_match(qr(xxx), q(xxx), 'NOT qr(xxx) |M| q(xxx)');
does_match(q(x), [qw(x y z)], 'q(x) |M| [qw(x y z)]');
done_testing;

