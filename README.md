[![Build Status](https://travis-ci.org/tacnoman/thumcno.svg?branch=master)](https://travis-ci.org/tacnoman/thumcno) [![Code Climate](https://codeclimate.com/github/tacnoman/thumcno/badges/gpa.svg)](https://codeclimate.com/github/tacnoman/thumcno)

Thumcno - A Tacno Thumbnail Generator in runtime
=================

## Pre requisites

To use thumcno, you need install the php-gd first.

```bash
 $ sudo apt-get install php-gd # Ubuntu
 $ sudo yum install php-gd # CentOs
 $ brew install php-gd # Mac OS
```

You must install composer too. [https://getcomposer.org/]

## Installation

```bash
git clone git@github.com:tacnoman/thumcno.git
cd thumcno
composer install
php thumcno config # Follow the instructions
php thumcno serve
```

Based on timthumb:
http://www.binarymoon.co.uk/projects/timthumb/

You can use for any projects with different domains.

## How it works?

There are many solutions to crop images. I like the timthumb solution.
The request goes to a php file with params. The crop happen in runtime and generate a cache file.
The Thumcno project, add a security for this and reuse for multiple projects.
It's veeeery easy to use! I'll show you!

#### First step:

You need to add your custom domain. You could run:

```bash
php thumcno domain:add img.mydomain.com
```

This command will generate a file called `img.mydomain.com.ini` in `/app/apps` directory.
This file contains the custom configuration for this domain (example: cache directory, etc).
This params will replace the params in default.ini (you can change it).

##### This is the `default.ini`.

```
; This document has default params
port = 80

debug_on = true    ; Enable debug logging to web server error log. Remember to update this param in your app
debug_level = 1 ; Debug level 1 is less noisy and 3 is the most noisy

memory_limit = 30M              ; Set PHP memory limit
block_external_leechers = false ; If the image or webshot is being loaded on an external site, display a red "No Hotlinking" gif.
display_error_messages = true   ; Display error messages. Set to false to turn off errors (good for production websites)

allow_external = false       ; Allow image fetching from external websites. Will check against ALLOWED_SITES if ALLOW_ALL_EXTERNAL_SITES is false
allow_external_sites = false ; Less secure.

file_cache_enabled = true              ; Should we store resized/modified images on disk to speed things up?
file_cache_time_between_cleans = 86400 ; How often the cache is cleaned

file_cache_max_file_age = 86400 ; How old does a file have to be to be deleted from the cache
file_cache_suffix = .thumcno    ; What to put at the end of all files in the cache directory so we can identify them
file_cache_prefix = null        ; What to put at the beg of all files in the cache directory so we can identify them
file_cache_directory = cache    ; Directory where images are cached. Left blank it will use the system temporary directory (which is better for security)
max_file_size = 10485760        ; 10 Megs is 10485760. This is the max internal or external file size that we'll process.
curl_timeout = 20               ; Timeout duration for Curl. This only applies if you have Curl installed and aren't using PHP's default URL fetching mechanism.
wait_between_fetch_errors = 3600; Time to wait between errors fetching remote file

; Browser caching
browser_cache_max_age = 864000 ; Time to cache in the browser
browser_cache_disable = false  ; Use for testing if you want to disable all browser caching

; Image size and defaults
max_width = 1500         ; Maximum image width
max_height = 1500        ; Maximum image height
not_found_image = null   ; Image to serve if any 404 occurs
error_image = ''         ; Image to serve if an error occurs instead of showing error message
png_is_transparent = true; Define if a png image should have a transparent background color. Use False value if you want to display a custom coloured canvas_colour
default_q = 90           ; Default image quality. Allows overrid in timthumb-config.php
default_zc = 1           ; Default zoom/crop setting. Allows overrid in timthumb-config.php
default_f = null         ; Default image filters. Allows overrid in timthumb-config.php
default_s = 0            ; Default sharpen value. Allows overrid in timthumb-config.php
default_cc = ffffff      ; Default canvas colour. Allows overrid in timthumb-config.php
default_width = 100      ; Default thumbnail width. Allows overrid in timthumb-config.php
default_height = 100     ; Default thumbnail height. Allows overrid in timthumb-config.php
```

You need to replace only the necessary.

## See working in local machine

To see in your local machine, run this commands:

```bash
cd /path/to/thumcno
php thumcno config
php thumcno serve
```

### Running with Docker

```bash
docker run -it -p 8888:80 tacnoman/thumcno ./thumcno server
# Sharing folder
docker run -it -p 8888:80 -v /path/to/thumcno/apps:/app/apps -v /path/to/thumcno/example_images:/app/example_images tacnoman/thumcno ./thumcno server
```

### Using with docker-compose

#### TODO THIS!

Now, go to your browser and open the url:

http://localhost:8888/?src=/dubai.jpg&w=200&h=200&q=80

You will see this:

![dubai thumb](./example_image/thumbnail.jpg)

Possible params
-------------------

This list is the params that you can pass in url ($_GET):


| parameter | stands for    | values                  | What it does                                                                                                                                                    |
|-----------|---------------|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| src       | source        | url to image            | Tells Thumbcno which image to resize                                                                                                                            |
| w         | width         | the width to resize to  | Remove the width to scale proportionally (will then need the height)                                                                                            |
| h         | height        | the height to resize to | Remove the height to scale proportionally (will then need the width)                                                                                            |
| q         | quality       | 0-100                   | Compression quality. The higher the number the nicer the image will look. I wouldn’t recommend going any higher than about 95 else the image will get too large |
| a         | alignment     | c,t,l,r,b,tl,tr,bl,br   | Crop alignment. c = center, t = top, b = bottom, r = right, l = left. The positions can be joined to create diagonal positions                                  |
| zc        | zoom/crop     | 0,1,2,3                 | Change the cropping and scaling settings                                                                                                                        |
| f         | filters       | too many to mention     | You can use the link above                                                                                                                                      |
| s         | sharpen       |                         | Apply a sharpen filter to the image, makes scaled down images look a little crisper                                                                             |
| cc        | canvas colour | hexadecimal color(#fff) | Change background colour. Most used when changing the zoom and crop settings, which in turn can add borders to the image.                                       |
| ct        | canvas transp | true (1)                | Use transparency and ignore background colour                                                                                                                   |
| style     | thumb sizes   | string                  | String to define the style of the size, for example, thumb=30x30, medium=200x200 and big=800x800                                                                |


Set possible sizes
-------------------

If you don't set the sizes, you could have a big security problem!
Suppose that your URI is this `<w>/<h>/<src>`. A hacker could make a script to generate ALL POSSIBLE SIZES in cache.
But, you can define the possible sizes to generate in your website. It's simple:

```
; <your_domain>.ini
; Possible_sizes
[sizes]
thumb = 30x30
medium = 200x200
large = 800x800
```

Now, you can generate thumbs only with sizes 30x30, 200x200 and 800x800.
If you don't want to show the size in the URL, you can use the `style` (like paperclip for ruby).

The style will replace the size. An example for this config is:

```ini
; <your_domain>.ini
[styles]
medium = 500x500
big = 800x700
```

`http://<domain>/?src=dubai.jpg&style=medium` -> Without friendly url.
`http://<domain>/medium/dubai.jpg`            -> Considering a friendly url, where the uri is `/(?P<style>\w+)/(?P<src>(\w|-|\.)+)`.

### URL Friendly

If you want to use friendly urls, you can set the params in your .ini file passing the URLS params. (You must know abour regex)
The param is `route` and you can use the same url params in this format:

```
(?P<name_of_param>\regex)
ex: (?P<w>\d+) -> Regex for para w (width) accepting only integers values

Another example:
^\/(?P<w>\d+)x(?P<h>\d+)\/(?P<q>\d{1,3})\/?
/<width>x<height>/<quality>/?src=example_images/dubai.jpg

One more example:
^\/(?P<w>\d+)x(?P<h>\d+)\/(?P<q>\d{1,3})\/(?<src>[\w.-]+)?
/<width>x<height>/<quality>/<source.jpg>
http://localhost:8080/200x200/80/dubai.jpg

Ps: If you don't set any params in your regex, you can pass like $_GET param.
```

### Bugs

`Send-me an email: <renatocassino@gmail.com>.`
