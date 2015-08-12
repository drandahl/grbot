# Description:
#   Get some random images under a random topic.
#   Used to be an April Fools joke, giving random bomb instead of pug/corgi
#
# Commands:
#   hubot random bomb <number> - Random images.
#   hubot <type> bomb <number> - Random images of <type>.

#------------------------------------------------------------------------------

# Feel free to add to or change things in the pizza and submit a pull request!

#------------------------------------------------------------------------------

# TODO: Clean all this up. It's still in a semi-hack state right now.
# TODO: Write topic balancer to sample from full set of uncurated toppings.
# TODO: Push curated data into external service.

#------------------------------------------------------------------------------

pluralize = require('pluralize')

module.exports = (robot) ->

#------------------------------------------------------------------------------

  # Shuffled queue of toppings, rebuilt from pizza and uncurated_pizza when
  # completely consumed.
  random_pizza = []

#------------------------------------------------------------------------------
  robot.respond /(.*) bomb( (\d+))?/i, (msg) ->
    query = msg.match[1]
    if other_bombs.test(query)
      return

    if /random/i.test(query)
      topping = random_topping()
    else
      topping = topping_for_query(query)

    count = Math.min((msg.match[3] || 3), 3)
    send_messages_for_topping(msg, topping, count)

#------------------------------------------------------------------------------

  random_topping = () ->
    if random_pizza.length == 0
      random_pizza = shuffle(pizza.concat(uncurated_pizza))
    random_pizza.pop()

  topping_for_query = (query) ->
    result = null
    pizza.forEach (topping) ->
      if topping["search_pattern"].test(query)
        result = topping
    if result
      return result
    else
      return uncurated_topping_for_query(query)

  uncurated_topping_for_query = (query, pluralizable = true) ->
    plural_name = if pluralizable then pluralize(query) else query
    {
      "plural_display_name": plural_name,
      "original_query": query,
      "curated": false
    }

#------------------------------------------------------------------------------

  send_messages_for_topping = (msg, topping, count) ->
    msg.send header_text(topping["plural_display_name"])
    if topping["curated"]
      images = sample(topping["items"], count)
      msg.send images.join("\n")
    else
      imageMe msg, topping["original_query"], count, (url) ->
        msg.send url

  header_text = (pluralized_topping) ->
    "Have some " + pluralized_topping + "..."

  # Shamelessly copied from google-images.coffee and reworked
  imageMe = (msg, query, count, cb) ->
    q = v: '1.0', rsz: '8', q: query, safe: 'active'
    msg.http('http://ajax.googleapis.com/ajax/services/search/images')
      .query(q)
      .get() (err, res, body) ->
        images = JSON.parse(body)
        images = images.responseData?.results
        if images?.length > 0
          images  = sample(images, count)
          for image in images
            cb "#{image.unescapedUrl}#.png"

#------------------------------------------------------------------------------

  sample = (array, number) ->
    shuffled = shuffle(array)
    shuffled.slice(0, number)

  # Shuffles array. Quick hack used in sampling elemenents above.
  # Adapted from the javascript implementation at http://sedition.com/perl/javascript-fy.html
  shuffle = (arr) ->
    arr = arr.slice(0) # clone array
    i = arr.length;
    if i == 0 then return false

    while --i
        j = Math.floor(Math.random() * (i+1))
        tempi = arr[i]
        tempj = arr[j]
        arr[i] = tempj
        arr[j] = tempi
    return arr

#------------------------------------------------------------------------------

  # Sung to the theme of https://www.youtube.com/watch?v=wusGIl3v044
  pizza = [
    {
      #Bezos... Put it in the pizza.
      "search_pattern": /bezos/i,
      "plural_display_name":  "Bezos",
      "curated": true,
      "items": [
        "http://www.bloomberg.com/ss/08/09/0929_most_influential/image/jeff_bezos.jpg#.png",
        "http://www.chrisfharvey.com/wp-content/uploads/2012/02/bezos1.jpg#.png",
        "http://www.bloomberg.com/ss/10/02/0225_angel_investors/image/007_jeff_bezos.jpg#.png",
        "http://www.keatleyphoto.com/wp-content/uploads/2009/02/jeff-bezos2.jpg#.png",
        "http://allthingsd.com/files/2011/09/bezos_laugh.png#.png",
        "http://www.seattletimes.com/ABPub/2005/07/09/2002371469.jpg#.png",
        "http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2014/11/19/1416434827115/17342eb3-7199-4a1b-bc62-153f6fcc488e-2060x1236.jpeg#.png",
        "http://andyunedited.ivpress.com/bezos.jpg#.png",
        "http://static4.businessinsider.com/image/4e2e94b1ecad04cb7b000034-480/jeff-bezos-smiling.png#.png",
        "https://c2.staticflickr.com/4/3675/9489389920_b640002265_b.jpg#.png",
        "http://photos.vanityfair.com/2015/01/30/54cc003d0a5930502f5f2cab_image.jpg#.png",
        "http://moneymamba.com/wp-content/uploads/2011/02/JeffBezos.png#.png",
        "http://www.teknorazzi.com/wp-content/uploads/2009/10/no-kindle-for-you-jeff-bezos.jpg#.png",
        "https://pbs.twimg.com/media/CDTamKEWYAADyT5.jpg:large",
        "http://media.salon.com/2011/12/jeff-bezos.jpg",
        "http://1.bp.blogspot.com/-tCuyMgo93pc/VFpZXI3FlcI/AAAAAAAAAU0/h5pGowsqhpM/s1600/bezosFinalv2.jpg",
        ":laugh4: :laugh: :laugh4: :laugh: :laugh4: :laugh: :laugh4:",
        ":laugh: :laugh2: :laugh: :laugh2: :laugh: :laugh2: :laugh:",
        ":laugh3: :areyouseriousrightnowbro: :laugh3: :areyouseriousrightnowbro: :laugh3: :areyouseriousrightnowbro: :laugh3:",
        ":laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh::laugh:",
        ":areyouseriousrightnowbro:",
        "https://thenarcissisticanthropologist.files.wordpress.com/2012/10/mrclean_cs_mrclean_logo.png",
        "http://www.entertainmentbuddha.com/blog/wp-content/uploads/2012/06/Burns.gif",
        "http://i.dailymail.co.uk/i/pix/2014/08/18/article-2727557-209B46CF00000578-545_634x423.jpg",
        "http://static4.businessinsider.com/image/531095ff6da8113f5f6e5f2d-480/jeff-bezos-amazon-ceo-portrait-illustration.jpg",
        ":laugh99: :laugh99: :laugh99: :laugh99: :laugh99: :laugh99: :laugh99: :laugh99: :laugh99:"
      ]
    },
    {
      #Star Wars... Put it in the pizza.
      "search_pattern": /ackbar/i,
      "plural_display_name": "Ackbar",
      "curated": true,
      "items": [
        "http://i.imgur.com/OTByx1b.jpg",
        "http://farm4.static.flickr.com/3572/3637082894_e23313f6fb_o.jpg",
        "http://6.asset.soup.io/asset/0610/8774_242b_500.jpeg",
        "http://files.g4tv.com/ImageDb3/279875_S/steampunk-ackbar.jpg",
        "http://farm6.staticflickr.com/5126/5725607070_b80e61b4b3_z.jpg",
        "http://farm6.static.flickr.com/5291/5542027315_ba79daabfb.jpg",
        "http://farm6.staticflickr.com/5250/5216539895_09f963f448_z.jpg",
        "http://static.fjcdn.com/pictures/Its_2031a3_426435.jpg",
        "http://www.millionaireplayboy.com/mpb/wp-content/uploads/2011/01/1293668358_bottom_trappy.jpeg",
        "http://31.media.tumblr.com/tumblr_lqrrkpAqjf1qiorsyo1_500.jpg",
        "https://i.chzbgr.com/maxW500/4930876416/hB0F640C6/",
        "http://i.qkme.me/356mr9.jpg",
        "http://24.media.tumblr.com/e4255aa10151ebddf57555dfa3fc8779/tumblr_mho9v9y5hE1r8gxxfo1_500.jpg",
        "http://farm2.staticflickr.com/1440/5170210261_fddb4c480c_z.jpg",
        "http://fashionablygeek.com/wp-content/uploads/2010/02/its-a-mouse-trap.jpg?cb5e28",
        "http://31.media.tumblr.com/tumblr_lmn8d1xFXN1qjs7yio1_500.jpg"
      ]
    },
    {
      #Star Trek... Put it in the pizza.
      "search_pattern": /star trek/i,
      "plural_display_name": "Star Trek",
      "curated": true,
      "items": [
        "http://www.eelanmedia.com/wp-content/uploads/2014/02/captains-log.jpg",
        "http://www.startrek.com/legacy_media/images/200307/worf03/320x240.jpg",
        "http://static.comicvine.com/uploads/original/11111/111118398/3075157-4811147398-khan..jpg",
        "http://www.startrek.com/legacy_media/images/200307/kirk01/320x240.jpg",
        "http://static.giantbomb.com/uploads/scale_small/3/34651/1199513-kirk.jpg",
        "http://www.blastr.com/sites/blastr/files/styles/blog_post_media/public/redshirts.jpg?itok=iDXjJoME",
        "http://upload.wikimedia.org/wikipedia/en/4/4c/Redshirt_characters_from_Star_Trek.jpg",
        "http://i.imgur.com/SVM5X8p.jpg",
        "http://i.imgur.com/psrvYFA.gif",
        "http://www.supernaturalwiki.com/images/3/38/Star_Trek_cast.jpg",
        "http://www.norvillerogers.com/wp-content/uploads/2014/09/2055-star-trek-wallpaper-1920x1080-wallpaper-5716.jpg",
        "http://www.eelanmedia.com/wp-content/uploads/2014/02/captain.jpg",
        "http://www.vitamin-ha.com/wp-content/uploads/2013/06/Funny-Star-Trek-10.jpg",
        "http://www.dumpaday.com/wp-content/uploads/2012/12/awkward-funny-star-trek-pictures.jpg",
        "http://www.baconwrappedmedia.com/wp-content/uploads/2012/07/funny-star-trek.jpg",
        "http://www.thenug.com/sites/default/pub/071813/thenug-LORwyKEe9E.jpg",
        "http://www.dumpaday.com/wp-content/uploads/2013/01/the-walking-dead-funny-star-trek.jpg",
        "http://iruntheinternet.com/lulzdump/images/startrek-dangerous-go-alone-redshirt-1348791892yf.jpg"
      ]
    },
    {
      #Doctor Who... Put it in the pizza.
      "search_pattern": /doctor|doctor who|who/i,
      "plural_display_name": "time lords",
      "curated": true,
      "items": [
        "http://upload.wikimedia.org/wikipedia/en/1/1a/First_Doctor_colour.jpg",
        "http://upload.wikimedia.org/wikipedia/en/8/8f/Second_Doctor_b.jpg",
        "http://upload.wikimedia.org/wikipedia/en/0/07/Third_Doctor.jpg",
        "http://img2.wikia.nocookie.net/__cb20140729213037/infinite-loops/images/0/09/The-Fourth-Doctor-doctor-who-22491789-800-600.png",
        "http://www.doctorwhotv.co.uk/wp-content/uploads/peter-davison-5th.jpg",
        "http://th05.deviantart.net/fs71/PRE/i/2012/099/f/c/sixth_doctor_by_butters101-d4vloka.jpg",
        "http://images.amcnetworks.com/bbcamerica.com/wp-content/blogs.dir/18/files/2013/05/Seventh-Doctor-2.jpg",
        "http://cdn2.denofgeek.us/sites/denofgeekus/files/styles/insert_main_wide_image/public/mcgann1.jpg?itok=VsY_5ZFZ",
        "http://images.amcnetworks.com/bbcamerica.com/wp-content/blogs.dir/55/files/2013/09/ninthdoctor.jpg",
        "http://images4.fanpop.com/image/photos/22500000/The-Tenth-Doctor-doctor-who-22518049-800-600.png",
        "http://img1.wikia.nocookie.net/__cb20120420000432/tardis/images/3/3e/Eleventh_doc_main_img.jpg",
        "http://images6.fanpop.com/image/photos/36100000/The-Twelfth-Doctor-image-the-twelfth-doctor-36103732-500-643.jpg",
        "http://www.bbc.co.uk/doctorwho/medialibrary/images/1024/s4_12_wal_07.jpg?size=1024&promo=/doctorwho/medialibrary/images/main-promo/s4_12_wal_07.jpg&purpose=Computer%20wallpaper&summary=The%20Supreme%20Dalek%20and%20his%20troops.&info=&tag_file_id=s4_12_wal_07",
        "http://fc07.deviantart.net/fs42/i/2009/078/c/4/Dalek_on_Duty_by_pippin1178.jpg",

      ]
    },
    {
      #Jurrassic Park... Put it in the pizza.
      "search_pattern": /dinosaur|raptor|rapture/i,
      "plural_display_name": "dinosaurs",
      "curated": true,
      "items": [
        "http://o.aolcdn.com/hss/storage/midas/9c71edd68e11a102eec617e7da3a259/200263670/jurassicpark_BIG.jpg",
        "http://www.underthegunreview.net/wp-content/uploads/2012/06/jurassic-park-4.png",
        "https://bethmatthewsbooks.files.wordpress.com/2014/08/blog-3.jpg",
        "http://cdn.screenrant.com/wp-content/uploads/Jurassic-Park-3-Raptors.jpg",
        "http://i.imgur.com/E08xU.png",
        "http://cdn1.sciencefiction.com/wp-content/uploads/2013/10/jurassicpark4148.jpg",
        "http://i.imgur.com/btI7IS2.jpg"
      ]
    },
    {
      #HP... Put it in the pizza.
      "search_pattern": /wizard|harry potter|hp|harry|potter/i,
      "plural_display_name": "wizards",
      "curated": true,
      "items": [
        "http://i2.cdnds.net/13/10/618x363/movies-harry-potter-and-the-half-blood-prince-voldemort.jpg",
        "http://wp.production.patheos.com/blogs/thegodarticle/files/2014/09/Carrey-as-Potter.jpg",
        "http://geekchicelite.com/wp-content/uploads/2014/07/harry.jpg",
        "http://www.geekycon.com/wp-content/uploads/2014/04/blog_potterpuppetpals.png",
        "http://i.ytimg.com/vi/or0-__NosSA/maxresdefault.jpg",
        "http://images5.fanpop.com/image/answers/2597000/2597259_1334184866061.24res_500_329.jpg",
        "https://s-media-cache-ak0.pinimg.com/736x/34/3c/e0/343ce07047a0f5d12f2bb6993f1aa037.jpg",
        "http://images1.memedroid.com/images/UPLOADED/4f8a11736c8ae.jpeg",
        "https://i.chzbgr.com/maxW500/7494692096/hA6235254/",
      ]
    },
    {
      #Cats... Put it in the pizza.
      "search_pattern": /cat/i,
      "plural_display_name": "cats",
      "curated": true,
      "items": [
        "http://www.aaanything.net/wp-content/uploads/2013/12/A_box_of_cute_kittens.gif#.png",
        "ttp://www.coonwirthy.com/mainecoonkittens.gif#.png",
        "http://media.giphy.com/media/mmZYRdvJb2WVa/giphy.gif#.png",
        "https://www.rover.com/blog/wp-content/uploads/2014/12/make-out-kittens.gif#.png",
        "ttp://media.giphy.com/media/mmZYRdvJb2WVa/giphy.gif#.png",
        "http://lookrobot.co.uk/files/2013/06/yawning-cat.gif#.png"
      ]
    },
    {
      #Pokemon... Put it in the pizza.
      "search_pattern": /pokemon/i,
      "plural_display_name": "pokemon",
      "curated": true,
      "items": [
        "http://www.picgifs.com/clip-art/cartoons/pokemon/clip-art-pokemon-208766.gif#.png",
        "http://31.media.tumblr.com/6bf19e5cdca136a996b34f9e4f2a1b23/tumblr_mid6jqiVDP1rxnlflo1_400.gif#.png",
        "http://www.picgifs.com/graphics/p/pokemon/graphics-pokemon-590971.gif#.png",
        "http://i1208.photobucket.com/albums/cc368/LittleCandyDucky/derpy-pokemon.gif#.png",
        "https://s-media-cache-ak0.pinimg.com/originals/7a/65/3b/7a653b441afb6dedf3dc4740fa0fb160.jpg#.png"
      ]
    },
    {
      #Batman... Put it in the pizza.
      "search_pattern": /batman/i,
      "plural_display_name": "batman",
      "curated": true,
      "items": [
        "http://zerowoes.com/wp-content/uploads/2014/01/funny-gif-new-batman-movie-ben-affleck-matt-damon20.gif#.png",
        "http://static.comicvine.com/uploads/original/11112/111123678/3503035-3468468-2718720139-batma.jpg",
        "http://media.dcentertainment.com/sites/default/files/GalleryChar_1920x1080_BM_Cv38_54b5d0d1ada864.04916624.jpg",
        "http://hotdigitalnews.com/wp-content/uploads/2013/09/batman_2.jpg",
        "http://www.wildsound-filmmaking-feedback-events.com/images/batman_pow_bam.jpg",
        "http://fc05.deviantart.net/fs70/i/2009/363/5/d/batman_VS_superman_high_res_by_westwolf270.jpg",
        "http://chaddickersonenglish12.weebly.com/uploads/1/3/7/8/13786540/717316_orig.jpg?0",
      ]
    },
    {
      #Zombies... Put it in the pizza.
      "search_pattern": /zombie/i,
      "plural_display_name": "zombies",
      "curated": true,
      "items": [
        "https://media.licdn.com/mpr/mpr/p/5/005/06a/1c8/1899274.jpg",
        "http://modernwarnegro.com/wp-content/uploads/2014/12/164531-zombies-zombie-wallpaper.jpg",
        "http://nintendoenthusiast.com/wp-content/uploads/2012/05/Zombies-on-Nintendo.png"
      ]
    },
    {
      #Books... Put it in the pizza.
      "search_pattern": /book/i,
      "plural_display_name": "books",
      "curated": true,
      "items": [
        "http://pngimg.com/upload/book_PNG2121.png",
        "http://wordpress.blackcardmarketingtopping.com/wp-content/uploads/2013/04/0530_WVlibraries.jpg",
        "http://www.betweenmylines.com/wp-content/uploads/2014/09/book_PNG2116.png",
        "http://cdn.visualnews.com/wp-content/uploads/2011/12/Guy-Laramee-Book-Carvings-16.jpg"
      ]
    },
    {
      #Penguins... Put it in the pizza.
      "search_pattern": /penguin/i,
      "plural_display_name": "penguins",
      "curated": true,
      "items": [
        "http://upload.wikimedia.org/wikipedia/commons/0/07/Emperor_Penguin_Manchot_empereur.jpg",
        "http://upload.wikimedia.org/wikipedia/commons/d/db/Pygoscelis_papua_-Nagasaki_Penguin_Aquarium_-swimming_underwater-8a.jpg",
        "https://viewsfromthesofa.files.wordpress.com/2012/05/penguin.jpg"
      ]
    },
    {
      #Disney... Put it in the pizza.
      "search_pattern": /disney|princess/i,
      "plural_display_name": "Disney",
      "curated": true,
      "items": [
        "http://upload.wikimedia.org/wikipedia/en/d/d4/Mickey_Mouse.png",
        "https://pmcvariety.files.wordpress.com/2013/07/frozen_wide.jpg?w=670&h=377&crop=1",
        "http://cdnvideo.dolimg.com/cdn_assets/4c4b3ee3cf63c82d77e04860c699876854bc4b79.jpg",
        "http://edmmaniac.com/wp-content/uploads/2014/05/The-Lion-King-the-lion-king-13191392-800-600.jpg",
        "http://img4.wikia.nocookie.net/__cb20140818222033/disney/images/1/18/Againstthetide115.jpg",
        "http://www.blastr.com/sites/blastr/files/Aladdin-disneyscreencaps.com-3602.jpg",
        "http://vignette1.wikia.nocookie.net/the-disney-roleplay/images/6/69/Lady-and-The-tramp.jpg/revision/latest?cb=20140917082754"
      ]
    },
    {
      #Breaking Bad... Put it in the pizza.
      "search_pattern": /walter|breaking bad/i,
      "plural_display_name": "Walter",
      "curated": true,
      "items": [
        "http://unrealitytv.com/wp-content/uploads/2013/10/bryan-cranston-walter-white.jpg",
        "http://www.edmlounge.com/storage/heisenberg.png?__SQUARESPACE_CACHEVERSION=1360440540556",
        "http://static.businessinsider.com/image/505879e6ecad048a47000000/image.jpg",
        "https://ccpopculture.files.wordpress.com/2013/08/breaking-bad-s3.jpg"
      ]
    },
    {
      #Paranormal Teen Romance... Put it in the pizza.
      "search_pattern": /paranormal teen romance/i,
      "plural_display_name": "paranormal teen romance",
      "curated": true,
      "items": [
        "http://rack.1.mshcdn.com/media/ZgkyMDEyLzEyLzA0L2I1L3R3aWxpZ2h0c291LmJUMi5qcGcKcAl0aHVtYgkxMjAweDYyNyMKZQlqcGc/ecb1e092/6e5/-twilight-soundtrack-debuts-tomorrow-morning-on-myspace-b3e70d39df.jpg",
        "http://public.media.smithsonianmag.com/legacy_blog/dracula-2.jpg",
        "http://www.chicagonow.com/acrimonious-clown/files/2015/01/the-vampire-diaries-201.jpg",
        "http://www.slj.com/wp-content/uploads/2012/08/SLJ1209w_Paranormal.jpg"
      ]
    },
    {
      #Friendship... Put it in the pizza. Shhhh! :P
      "search_pattern": /pony|friendship/i,
      "plural_display_name":  "ponies",
      "curated": true,
      "items": [
        "https://lh3.googleusercontent.com/-a1PMXvONOgs/VLzuAxQTzQI/AAAAAAAB6QY/uLduGHdk-mc/s1600/mylittlehumans.png",
        "http://i.imgur.com/7GPEbkN.png",
        "http://i.imgur.com/PwHRc.gif",
        "http://i0.kym-cdn.com/photos/images/newsfeed/000/193/709/Jesus_Christ_how_horrifying-(n1308183251036).png?1320087196",
        "http://4.bp.blogspot.com/-nAd7on1JI-Q/TpwDSB9OaXI/AAAAAAAAAD0/e_HNBhIJe9U/s1600/50831+-+artist-tess+monitor_punch+twilight_sparkle.jpg",
        "http://i.imgur.com/5qauBpT.png",
        "https://derpicdn.net/img/view/2014/10/2/734198__safe_rarity_applejack_rarijack_eating_popcorn_artist-colon-bitz.png",
        "http://www.fimfiction-static.net/images/story_images/102567.png?1368037960",
        "http://fc00.deviantart.net/fs70/i/2011/337/7/f/weekly_vector_7__party_cannon_by_gratlofatic-d4i38os.png",
        "https://derpicdn.net/img/view/2013/3/17/272920__safe_applejack_photo_edit_irl_ponies+in+real+life_realistic_horse_fence_real.png",
        "http://www.gameinformer.com/cfs-filesystemfile.ashx/__key/CommunityServer-Components-PostAttachments/00-01-30-56-31/Link-Derpy.png_2D00_500x400.png"
      ]
    },
    {
      #Matrix... Put it in the pizza.
      "search_pattern": /matrix/i,
      "plural_display_name": "matrix|neo",
      "curated": true,
      "items": [
        "http://i.ytimg.com/vi/HUSSKWWg-0c/maxresdefault.jpg",
        "http://theawesomedaily.theawesomedaily.netdna-cdn.com/wp-content/uploads/2015/03/1413474840_Matrix-Wallpapers.jpg",
        "http://i.huffpost.com/gen/799955/images/o-THE-MATRIX-AND-HINDUISM-facebook.jpg",
        "http://vignette2.wikia.nocookie.net/matrix/images/d/df/Thematrixincode99.jpg/revision/latest?cb=20140425045724",
        "http://static.guim.co.uk/sys-images/Film/Pix/pictures/2008/06/06/matrix460.jpg"
      ]
    },
    {
      #Simpsons... Put it in the pizza.
      "search_pattern": /simpson|simpsons/i,
      "plural_display_name": "Simpsons",
      "curated": true,
      "items": [
        "http://upload.wikimedia.org/wikipedia/en/a/aa/Bart_Simpson_200px.png",
        "http://upload.wikimedia.org/wikipedia/en/e/ec/Lisa_Simpson.png",
        "http://upload.wikimedia.org/wikipedia/en/0/0b/Marge_Simpson.png",
        "http://img2.wikia.nocookie.net/__cb20141025143218/simpsons/images/8/83/Homer_Simpson2.jpg",
        "http://upload.wikimedia.org/wikipedia/en/9/9d/Maggie_Simpson.png"
      ]
    },
    {
      #Music... Put it in the pizza.
      "search_pattern": /jazz/i,
      "plural_display_name": "jazz",
      "curated": true,
      "items": [
        "http://upload.wikimedia.org/wikipedia/commons/0/0e/Louis_Armstrong_restored.jpg",
        "http://www.localnomad.com/en/blog/wp-content/uploads/2013/10/jazz-notes.jpg",
        "http://www.thejazzsession.com/wp-content/uploads/2010/05/jazz_standard.jpg",
        "http://take5jazzandblues.com/wp-content/uploads/2014/07/jazz1.png"
      ]
    },
    {
      #Music... Put it in the pizza.
      "search_pattern": /rock/i,
      "plural_display_name":  "rock",
      "curated": true,
      "items": [
        "http://topwalls.net/wp-content/uploads/2012/02/hard-rock-music-guitar.jpg",
        "http://i.kinja-img.com/gawker-media/image/upload/s--t_R9qLoc--/c_fit,fl_progressive,q_80,w_636/770815643221531569.jpg",
        "http://news.bbcimg.co.uk/media/images/59575000/jpg/_59575151_dsc_0622.jpg-version2.jpg",
        "http://cache.lego.com/r/catalogs/-/media/franchises/minifigures%202014/characters/series%2012/71007_detail_rockstar.jpg?l.r=1110555369"
      ]
    },
    {
      #Music... Put it in the pizza.
      "search_pattern": /piano/i,
      "plural_display_name": "piano",
      "curated": true,
      "items": [
        "http://beckerspianotuning.webs.com/Piano%20keys%20with%20hand.jpg",
        "http://www.fortepianolessons.com/p6.jpg",
        "http://johncavacas.com/wp-content/uploads/2012/05/Piano-player-on-Saint-Germain.jpg",
        "http://cl.jroo.me/z3/w/9/_/d/a.baa-Epic-Piano-Player.jpg"
      ]
    }
  ]

#-----------------------------------------------------------------------------

  # Some uncurated toppings to fill out random bomb
  uncurated_pizza_pluralizable = [
    #Animals... Put them in the pizza.
    "spider", "shark", "bear", "lizard", "falcon", "frog",
    # "scorpion", "koi", "otter", "snake", "starling", "salamander",
    # "lobster", ""
    #,...
    #Random objects... Put them in the pizza.
    "iPhone", "soda", "boat", "keyboard", "kite", "refrigerator",
    # "paper", "tulip",
    #,...
  ].map (query) -> uncurated_topping_for_query(query, true)

  uncurated_pizza_not_pluralizable = [
    #Celebrities... Put them in the pizza
    "Justin Beiber", "Beyoncé", "Tom Cruise", "Kanye West", "Lady Gaga", "Katy Perry",
    # "Taylor Swift", "Brad Pitt", "Emma Watson", "Kristen Stewart", "Jon Stewart",
    #,...
    #Popular Shows... Put them in the pizza.
    "Dexter", "Game of Thrones", "Daredevil", "Supernatural", "Bing Bang Theory", "How I Met Your Mother",
    #,...
  ].map (query) -> uncurated_topping_for_query(query, false)

  uncurated_pizza = uncurated_pizza_pluralizable.concat(uncurated_pizza_not_pluralizable)

#------------------------------------------------------------------------------

  #I want pizza. P-I-Z-Z-A. Gimme pizza.
  #How much does it weigh? I want pizza.
  #P-I-Z-Z-A. I want pizza.
  #Is it finally done?
  #hooray!

  #Here it is, ready to serve.
  #This pizza is made...Yeah!

#------------------------------------------------------------------------------

  other_bombs = /(pug)|(corgi)/i


