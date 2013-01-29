#!/usr/bin/perl

# plugin.pl - plugin handler.

use strict; # Because I'm a good boy.
use warnings; # Because undefined values are an arse.

use MaDAME::Config;

our ( $plugin_dir, $plugin_ext );

sub handler_init {
# Handles start-up options.

    $plugin_dir = $cfg{musdat}{PluginDirectory} || $cfg{global}{pwd} . '/src/musdat/plugins/';
    $plugin_ext = $cfg{musdat}{PluginExtension} || '.mod';

}

sub detect_all_plugins {
# Check plugin directories as defined in the config, and build list of known plugins.

}

sub check_all_plugins {
# Run through list of detected plugins and check plugins for syntax errors etc.

}

sub load_plugin {
# Open file, trim blank lines, dump in array, close file.

}

sub parse_plugin {
# Extract and store information/instructions from the plugin.

}

sub exec_plugin {
# Execute instructions from parsed data.

}

sub bench_plugin {
# Benchmark plugins for debugging purposes.
