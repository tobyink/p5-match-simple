=pod

=encoding utf-8

=head1 PURPOSE

Test that match::simple and match::smart compile.

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

{
	package Local::Foo;
	::use_ok('match::simple');
}

{
	package Local::Bar;
	::use_ok('match::smart');
}

done_testing;

