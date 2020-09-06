#! /usr/bin/env luajit
print( 'Lua version:',  _VERSION )

--==================================================================================================
--  https://github.com/siffiejoe/lua-fltk4lua/wiki/GettingStarted  ---------------------------------

local fltk  = require( 'fltk4lua' )
fltk .scheme( 'gtk+' )

local w_width  = 430
local w_height  = 250
local title  = 'DualEndian'

local window  = fltk .Window( w_width,  w_height,  title )

--==================================================================================================
--  functions  -------------------------------------------------------------------------------------

local function dec( num )
    return tostring(  tonumber( num,  10 )  )
end  --  decimal()


local function hex( num )
    return tostring(  tonumber( num,  16 )  )
end  --  hexidecimal()


local function endian( num )
    if #num % 2 ~= 0 then  num = '0' ..num  end  --  even things out

    local reversed  = ''
    for i = 1,  #num,  2 do
        reversed  = reversed ..num :sub( -(i +1),  -i )
    end  --  reverse

    if #reversed % 2 ~= 0 then  reversed = '0' ..reversed  end  --  padding
    return reversed
end  --  endian()


--==================================================================================================
--  widgets  ---------------------------------------------------------------------------------------

--  dec  --

local alternate_decimal  = fltk .Input( 80,  20,  200,  25,  'Reversed' )
alternate_decimal .type  = 'FL_NORMAL_OUTPUT'
alternate_decimal .labelcolor  = 39

local decimal_input  = fltk .Input( 80,  50,  w_width -100,  36,  'Decimal' )
decimal_input .textsize  = 25
decimal_input .labelcolor  = 136
decimal_input .cursor_color  = 45

--  little hex  --

local little_endian_dir  = fltk .Box( 80,  108,  200,  20,  '>>  >>  >>  >>  >>   LSB' )
little_endian_dir .labelsize  = 15
little_endian_dir .labelcolor  = 45

local little_endian_input  = fltk .Input( 80,  130,  200,  36,  'Little   0x' )
little_endian_input .textsize  = 25
little_endian_input .labelcolor  = 136
little_endian_input .cursor_color  = 45

--  big hex  --

local big_endian_input  = fltk .Input( 80,  170,  200,  36,  'Big   0x' )
big_endian_input .textsize  = 25
big_endian_input .labelcolor  = 136
big_endian_input .cursor_color  = 45

local big_endian_dir  = fltk .Box( 80,  210,  200,  20,  '<<  <<  <<  <<  <<   MSB' )
big_endian_dir .labelsize  = 15
big_endian_dir .labelcolor  = 45

--==================================================================================================
--  callbacks  -------------------------------------------------------------------------------------

local function redraw()
    decimal_input :redraw()
    little_endian_input :redraw()
    big_endian_input :redraw()
    alternate_decimal :redraw()
end  --  redraw()


function decimal_input :callback()
    little_endian_input .value  = string.format( '%x',  decimal_input .value  ) :upper()
    big_endian_input .value  = endian(  little_endian_input .value  )
    alternate_decimal .value  = tonumber(  big_endian_input .value,  16  )

    redraw()
    decimal_input :take_focus()
end


function little_endian_input :callback()
    little_endian_input .value  = little_endian_input .value :upper()

    decimal_input .value  = tonumber(  little_endian_input .value,  16  )
    big_endian_input .value  = endian(  little_endian_input .value  )
    alternate_decimal .value  = tonumber(  big_endian_input .value,  16  )

    redraw()
    little_endian_input :take_focus()
end


function big_endian_input :callback()
    big_endian_input .value  = big_endian_input .value :upper()

    little_endian_input .value  = endian(  big_endian_input .value  )
    decimal_input .value  = tonumber(  little_endian_input .value,  16  )
    alternate_decimal .value  = tonumber(  big_endian_input .value,  16  )

    redraw()
    big_endian_input :take_focus()
end

--==================================================================================================
--  main  ------------------------------------------------------------------------------------------

window :end_group()
window :show()
fltk .run()

--==================================================================================================
--  eof  -------------------------------------------------------------------------------------------
