
""" Tilebitch is a python + PIL (Python Imaging Library) utility for converting
    a folder full of tiles into a single tilemap, as well as producing a generated
    lua file containing a mapping between the tile's name and the tile's position 
    in the map. 

    The tiles are expected to be defined as .png files, and expected to be of a 
    uniform height and width.

    Usage: 
    $> echo 'Creating directory structure'
    $> mkdir tiles
    $> mkdir tiles/set_one
    $> mkdir tiles/set_two
    $> mkdir tile_output

    $> echo 'Adding files'
    $> mv hate_poop.png tiles/set_one/hate_poop.png
    $> mv moustache_ride.png tiles/set_one/moustache_ride.png
    $> mv tromboner.png tiles/tromboner.png
    $> mv shamwow.png tiles/shamwow.png

    $> echo 'Running Tilebitch'
    $> python tilebitch.py --input tiles --output tile_output --output_moai game/tile_output/ 

    $> echo 'Produces this:'
    $> ls tile_output
        set_one.lua
        set_one.png
        set_two.lua
        set_two.png
    $> cat tile_output/set_one.lua
        -- this is an tilebitch generated file
        -- warning: your modifications will be overwritten
        source = "game/tile_output/set_one.png"
        height = 128
        width = 128
        length = 2
        tiles = {
            hate_poop = 0x1,
            moustache_ride = 0x2
        }
    $> cat tile_output/set_two.lua
        -- this is an tilebitch generated file
        -- warning: your modifications will be overwritten
        source = "game/tile_output/set_two.png"
        height = 16
        width = 16
        length = 2
        tiles = {
            tromboner = 0x1,
            shamwow = 0x2
        }

"""

# Parse the command-line input variables into 'input' and 'output'
import argparse
import os
import Image

parser = argparse.ArgumentParser(description='Create a tile and a descriptor file.')

parser.add_argument( '--input', dest='input', default=False,
    help='directory containing directories full of tiles')

parser.add_argument( '--output', dest='output', default=False,
    help='target directory')

parser.add_argument( '--output_moai', dest='output_moai', default=False,
    help='the output directory from the point of view of the moai base directory.')
args = parser.parse_args()

if not os.path.exists( args.input ):
    print args.input, " is not a valid path. Please provide an --input argument to tilebitch.py."
    exit()

if not os.path.exists( args.output ):
    print args.output, " is not a valid path. Please provide an --output argument to tilebitch.py."
    exit()

if not os.path.exists( args.output_moai ):
    print args.output, " is not a valid path. Please provide an --output_moai argument to tilebitch.py."
    exit()
# List the subdirectories of input
files = {}

for thing in os.listdir( args.input ):
    title = thing
    path = os.path.abspath( os.path.join( args.input, thing ))
    if os.path.isdir( path ):
        directory_name = path
        files[title] = []
        for thing in os.listdir( directory_name ):
            file_path = os.path.abspath( os.path.join( args.input, directory_name, thing ) )
            if os.path.isfile( file_path ):
                file_title = thing[:-4]
                files[title].append(  ( file_title, file_path ) )
            else:
                print thing, " is not a file"
    else:
        print thing, " is not a directory" 

# this should give us a structure that looks like
# { 'directory_one': [ ("one", "C:\\path\\to\\directory_one\\one.png"), 
#                        ("two", "C:\\path\\to\\directory_one\\two.png" ) ],

for directory_name, list_of_files in files.iteritems():
    
    #Merge the images
    if len(list_of_files) == 0:
        continue
    first_file_path = list_of_files[0][1]
    proto_image = Image.open(first_file_path)
    width = proto_image.size[0]
    height = proto_image.size[1]

    master_image = Image.new( "RGBA", (width * len(list_of_files), height ) )
    current_stop = 0
    for file_title, file_path in list_of_files:
        this_image = Image.open( file_path ) 
        master_image.paste( this_image, (current_stop, 0) )
        current_stop += width

    master_image.save( os.path.join( args.output, directory_name + ".png" ) )

    #Create the LUA
    string = """
module(..., package.seeall)
--- this is a tilebitch generated file
--- warning: your modifications will be overwritten\n"""
    string += "source = \"" + args.output_moai + directory_name + ".png"  + "\"\n"
    string += "length = " + str(len(list_of_files)) + "\n"
    string += "height = " + str(height) + "\n"
    string += "width = " + str(width) + "\n"
    string += "tiles = { \n" 
    counter = 1
    for file_title, file_path in list_of_files: 
        string += "\t" + file_title + "=" + str(hex(counter)) + ",\n"
        counter += 1
    string += "}"

    with open( os.path.join( args.output, directory_name + ".lua" ), "w" ) as lua_file:
        lua_file.write( string )
