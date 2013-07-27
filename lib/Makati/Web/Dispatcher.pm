package Makati::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use Makati::Pages;

use Try::Tiny;

any '/' => sub {
    my ($c) = @_;
    return $c->render('index.tt');
};

get '/pages/:page' => sub {
    my ( $c, $args ) = @_;
    my $pages = Makati::Pages->new( dir => $c->config->{pages_dir} );

    try {
        my $p = $pages->fetch_and_render( $args->{page} );
        return $c->render( 'pages.tt', { p => $p } );
    }
    catch {
        return $c->res_404;
    };
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
