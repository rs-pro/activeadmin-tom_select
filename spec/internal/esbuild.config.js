#!/usr/bin/env node
const esbuild = require('esbuild');
const path = require('path');

// Configuration for esbuild with proper module resolution
const config = {
  entryPoints: ['app/javascript/active_admin.js'],
  bundle: true,
  sourcemap: true,
  format: 'iife',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  // Add node paths for module resolution
  nodePaths: [
    path.join(__dirname, 'node_modules'),
    path.join(__dirname, '../../node_modules')
  ]
};

// Check if we're in watch mode
const watchMode = process.argv.includes('--watch');

if (watchMode) {
  // Start the build with watch mode
  esbuild.context(config).then(ctx => {
    ctx.watch();
    console.log('Watching for changes...');
  });
} else {
  // Single build
  esbuild.build(config).then(() => {
    console.log('Build completed');
  }).catch(() => process.exit(1));
}