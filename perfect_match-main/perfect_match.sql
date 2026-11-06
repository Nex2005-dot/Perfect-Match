-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: perfect_match
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `analyses`
--

DROP TABLE IF EXISTS `analyses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analyses` (
  `id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int unsigned NOT NULL,
  `created_at` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `skin_tone` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `skin_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `undertone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `confidence` int NOT NULL,
  `palette_json` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_data` mediumtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `analyses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analyses`
--

LOCK TABLES `analyses` WRITE;
/*!40000 ALTER TABLE `analyses` DISABLE KEYS */;
INSERT INTO `analyses` VALUES ('ana_c744c23f',1,'2026-10-05T08:59:39','Dark','Combination','Neutral',90,'{\"foundation\": [{\"name\": \"Natural Beige\", \"hex\": \"#998471\", \"note\": \"Works with both warm and cool tones.\"}, {\"name\": \"Soft Honey\", \"hex\": \"#8B715A\", \"note\": \"A balanced, natural finish.\"}, {\"name\": \"Light Almond\", \"hex\": \"#816752\", \"note\": \"A versatile everyday shade.\"}], \"blush\": [{\"name\": \"Soft Rose\", \"hex\": \"#E8A0A0\", \"note\": \"A gentle, universal flush.\"}, {\"name\": \"Dusty Peach\", \"hex\": \"#E5A58F\", \"note\": \"Natural warmth without being orange.\"}, {\"name\": \"Mauve Pink\", \"hex\": \"#CC8E96\", \"note\": \"Soft color for daily wear.\"}], \"lip\": [{\"name\": \"Rosewood\", \"hex\": \"#A8575F\", \"note\": \"A flattering muted rose.\"}, {\"name\": \"Soft Berry\", \"hex\": \"#A04A62\", \"note\": \"Adds color without being harsh.\"}, {\"name\": \"Brick Rose\", \"hex\": \"#B25D50\", \"note\": \"A warm-leaning neutral.\"}, {\"name\": \"Nude Pink\", \"hex\": \"#C48B88\", \"note\": \"An easy everyday nude.\"}], \"eyeshadow\": [{\"name\": \"Soft Brown\", \"hex\": \"#8A6A5C\", \"note\": \"A classic, easy-to-blend shade.\"}, {\"name\": \"Rose Gold\", \"hex\": \"#C99A8C\", \"note\": \"Adds a pretty shimmer.\"}, {\"name\": \"Mocha\", \"hex\": \"#6F4E40\", \"note\": \"Great for defining the crease.\"}, {\"name\": \"Champagne Pink\", \"hex\": \"#E0C4B8\", \"note\": \"A soft highlight shade.\"}]}','data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAEOAeADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDi7e3BxgYHoavpEB/D053Y6UkEZxk5KkcVaU7U8vcSM1zyZDEEasxA4IHOelRMNuQQQueTjrT9p3EkY5qMux4JxjoAKzsxIYYzgnOaVI+v1FDHjgkZ9etOjchxj8Qe9LyLT1NaONTCDjtTba5HneS0eM/dzyDVqJR5a4OVIxUa2v71Wxnacj1rLUpWNCOCGQZxirUEKN9zawHpVVUOMfrUttG6zqeRgEE+oqrtWRS7l6O1j5O0DIoayV+OARTyzhBtOCDmrW7KZ6HGaqyeg7vcggsljQKBgCkltBuDYAwc5p8dwzyBJEwCflIPWpLmVY4yOcd8U9Ghq6M++UGNtvHuKxdTkUWhVjg4G6ta8nEFs0nDf3R61wl3qQv5nZGOxWwVpW5pWE5WGNiSQk/nWnoDCLWLfI4clSPqKygSM9qsWlwbe5inXny3DY+lbPsQnrc9SigQxBCOnSpREqADrmooriKURPFkb1DAeoNTzA+U20YPasEup03YCBCfu/erQtIxIgRQODVW1B8oZycd6u2jCNeRyK0iJ3udBZQRRqXXk9DV24JVECjHfNUtOVvsa5OSxyasXdwq4HXaOa1SuiXuVLrdKMZGf5Vds1SO32qAf7x9TWVcXBVgqpuPf2q4khSweVByBx9atct79Qd9i6tvAz7nQFqoaneiNfKhA4rPt7m78w7pGZT0qvJcKsp8yVRJ/eb7o/8Ar1UWnqQ79SrcWMjqWl5Y9AOSfwrOeSKO2lC2qRon/LSbOWPfArXh1uN9SWwto1mupwVDu2OgyadY6FHMZJb5jLOj/NA/3U9DjuPenZX5gbsrHB3/ANomlj3B5I2kEe4cIGPIFdn4f8NQ6W0z7y8ku3PGAP8AJrM8SMi+ZGpAK6lCSPT93XaaWQ0b7v8AZI/KpRFzIvLJQxG2uL8a26r4euDjGGX/ANCFek3kQYVw/jqHHhq7IHTb/wChCk0I8dXG0KByCTn8qniUeYeM8CoVGTVlG2y9/uikJlqOIkD5Tz9al8on+D9KEbI74/3TU2PY/wDfNS7CIxAcfcWnCL/dHFSfgR+AoJOeh/MUAReV/tD8DTDET0b9DVgBjnAP5mkZWB6DP40IL2K5hHdj+VRXEYW0cf3iF/Mgf1q0I25yB+VMmRvLhTj5pl/Q5/pQBVvEAjuf9z+hqnqSeVf2bDpu5/Qf4Vo3oO26z/cH9aqa2p/cEcHc2P8AvnP9KAuWNZuBPfWKZH+jWmz8S7t/7MKx1UGZj2qzcsHv5nHI2L/LNSaZa/ab+OLrk5NZz3OiNy1PYmzaEt0mhDDPrVcqHjb6V2PiKxA0WOYAboHH5Hg/0rkQANwJOaVrFbjNPwpdB2NaFxCHjLAdayom8q7I/vCtuBfNiGDgihsSeljEnjPlk1atwGiUn0qW7gIB9c1BYkeXtJ+6SKaegtbj7iMYzxUEqAxNxxgVauQcdRUD8wkjvTVw3IrJMlhjv2raghCAjGMGsCC4EF5DuOFZ9v6HH611uwY3eo/OuinojnqXucz4nkFvpjlfvOdg/rXDbQWKkHJPHvXpeu2sc1iUkUMP5Vwi2gjvRl+FYHkU2iFsegRplQScqPQZxSuuO/Xoc09SHj3KmABgnoTSeXjLYJyevpXM2P1Kx6k7c496jf7pY4I+tTyAbiE4x3J61XccE84NJoZH97rj2pwbB9gaibn5f0zS5wDz9KWpSOgtLhXRPL5Q/eHdT6/SrZmESliMkds9a52yvGtXOAPmq8zzQknHnQSHIxyUrNqyLVjahuUlThSGU8g9qkNyFdVJwx6e9VYrdlh81RnPUCnxxPO2NvQgg+mKLuyH1Ne2mWQEMOaukggA/rVCOPbEx/i9qlt2dsqSSgGQT1FXzJOw0tCcKqEfXimzBBGS5wBzmo52Kr8hwSevXFUNSuXGnvvwpAyx7VLsrpFLuzL8Q3ixWiIjAl/u+w9a4K4zZ3IuFz5TnEg9PetW6unuZQzH5VGB9KrOqyIUYZU8EVpBWWpk3dkiuGG5TlT0NSqaybV2tJ2tZCSnWNj6elaanmrYrne+FL9bq0FvJIFmg4Ge69vyrtN8RRVYgM36141ZXkljcx3Ef3kOceo9K9HsdVF/BFKi5jY468g1jKPK7m8J391nQQSRwZ3YCipJXjO14zhTjIqF4lkhAzycUOgSEA9RVJtlHQWNyflQDjHB9qQnz2PuelQ6U0UWn+ZK3ONoNSQSxwI0oyT/AAn0rRLW4mFzA0J8w/ebjae1WCxjsSTwoH51Rhle/u1Vmxk889qZqt95R3r8sEXA3cZPrVrl3Qm3sZ0188z5ybaBDyf4m9q5TxH4hjuI2tYAhTplD/OqniHXlvJnW3ZgT95weD9K5bd5FwUbOyXlfr6UKy0RnKVy9aXU9veRXMUjCaJgyMT0Ir2e3nXVtPt76Jijuu+NvTPVT6jOQR7V4kjqM5IFdv4J8S29vBLp9xcRLGh81NzAEZOCB+hppk3KOsTrJrGtSj7y3doSuehCMD+or0fTOYS2eoFed69PaTale3FtNA6SyQFmDDkrnn9T+Vdto1z5jLtdTGUBOKL6gbcihkrjvHkQ/wCEUvzjoqn/AMeFdcZBjrgHpXNeOAH8IalgdIh/6EKbEeFbf3anHcjNWET94pAzlR/M1F/y7L/v1YTiVOM5Tp+NRfQVy7GvA+UY96nVMnoo/Kooj0O0/kKsBieNp/MVJIBfcfnSlT03fzpRv7Lx/vU7Den86B3IipBxkn8DSMoJ5z+VPKPn7q/jmmmNsnG38qAGFRj2/Co3VTPar1wzP+Qx/WpWR/7wApkKk3pyc7Isfix/+xFMRBdj5LvGP9Vn+dUdeX/RYWH8Muf0NaN4P3N4R/zyx+hqvqsfmQogHJY/+gmhD3MuQfMuBy0UZ+vFbnhG387UmlYfLGv61zkErSWiyMckDb9McCu58G2pSyeYj77j8qmWrOiOiN7WLdrjSZbdR80ik/lyP1rzkH+IivUmJLFsA9hXnmsWn2PVriEcKTvT6HmiS6jizMuIz5sUi8gHBNalhKF+Vuhqg/MTKeeOlNt5sxq3p1qbdgRtXEW9cgVjIPIvGQ9G5HFbVtMJoOvPSszU4TxKnDLzmhLoK424O5RjvUcvEIA+tJHJ5sSnv3FLMAEA4zT9AMDVW2yRYbGCW4rudJma60u2nc43rmuC1gj7Ui+i5r0DQ4lXRLIA8eUDXRTWhz1XqRasoMJHXiuEnGLtyBmvQNSUG3bHJ6CuFnXF03T6VctyU9DuItpCjkH0AoKcDBwDnFORBsHRlPG4/wAqftj+6M8+/I+lcbH1KMiAFsDH1NVznB4x2Iq9IvHzHce3HWqr85xjP0oe4ylL0DAcfWoyxI6Ae9WZEO7JANVnXbz60WGhwbDcnpVuyu/JlAc/u88g81RB64HPvSg+uDSGjvdPkQrhOYT0I7VeMMaEuy7cfxL3rh9J1NrScRyEiFjz7e9dm12QiBAHt2XIbOcfjUSfKrmkdS7EgKbkYOvqP8KYx7Age1R2hZiXX7relJfiMhBMwAJwG6EGhTfLew7akF9cG2g44ZuhrlNf1LzI47dG5I3SY9fStXWr7+z4xl1ld+FVuo964qR2kcu5ySckmnFNyv0Jk1ayDoTRmkAyKXGM1qQR3MC3Ee08MDlW9DTIboxny7kbXH8XY1P7Y6U4qGyrKGHoRRuArXcMaj5gSegXmtfw3rdxZ3TJOAlpL27qf71ZMVuikEKM1Pt28+1DSe407O56/Y3W+3U9Vx1z2qxIzEKcnrXnega7IHj05mIdfmQn+JR1FekMVktElXuM4rPZ2N07q5ZjkzpyoVyOpp0l0sECRsM7xjI7VSeZooUTBBIBqrJcu+9ipBHAHtWkV1BssC9aATGOTYpGNzHG7/61cXq+vXGosYEuHa3Xtv3Bvce1VfEniWKcSWa8Igxz6+n0rgpL+R0WCNv3aDG7pimkkrGU56nQXmoQ26n5hu7LWS+rPcIFZVVlYFWHtVJVLuCfmVR3/iqJVljl3CIMGPGe1VYzuW5J5DucyO3rzQko3DLKVxwapnzeGf5APSq0jOhJUgjPpVXQjWkJ+6suAeoIq/pvinV9GVktrgovTOM/lmuaadioK5Vu47VPFNMNrSJuj7+1ArnpFl8VrxtkOoW6MgI+dM549RXR6t4tsNZ8L6lFBMoXyMLuOCzfT8K8TmZXIeNfyplvO6glvwp9bBzWNsPmNQDnkd/rWhGvzx+6cfnXNrdNCcZyCc4rasL9JRHjkgEYB96lod7m7EmB2yanCnGBzTIw5UYjOP8AeqYLKP4B+ZrN6MAVDznr+NIUzxk/iKkCSZ5VcfjS+W+f4fypagQlAOD/AEpCo9QKl8ts9vyppifOd5Ap+gERC7cdvrUNogMlxIOSZNvPsB/XNTmJieZG4qKyCpYCRnwGd2JPfLGi+gFa84W6XbndF/Q1HcFZJoORjl/5D+tQXV632ltqblI25PH+etV7NjKjNKxIUrEBnA4PNNAtCnDa+ZqElpH0a4JX/dJzXqOmwx2tkEUYWNa82jupbTU2mVFRjkDcMgYrr9J1ZprLZNKryFskjjNSt9TdPSx0Jmb7qrnvmuY8V2jiKG9HzMpKP7A9K2Bdbv8A61R3LR3VpJbyrlHXaathGVjg3fdGCCB61BYuplkhADZO4c1HqCy2N1LBKM4OPqPWqdvLsuFcN8vQ46gVFh3tsdBayCKX5Sdp4ZT2qW4cSAjOe30rKS8WMnflsDse1Ri4VgD3JoUX1FcY7tbTEgcdx61ZNysqqVPHT6VXusMgbvis4StE2QapeQvIq6lKJNQkx0XC13FhrdhZ6DaOZBkR7cZxyOteeMxkd3IySxNRsflPpW8XyoykrnTax4rmncxWbKsXUtt6n2rEbU3L5dQzeoNUwCVJ96CM5pt9RW0PVV3qFVkVlbqV61Mv905bHIJGaZAxYKFUgN0J7fjUpIXKM4YA8n0NcmjAYY98ZII453EZFU5ABkg4x6HOavNh1wGYBeflHB96rzREcqQ3cD0FTsBmy7gOCD61Aw39e9WpAeoGKgKnGT/+qrGiswx1PfpRz6VK6k84GRUO3HPP40tLDQo+mK0dO1a4sW2K5MJ+8vas7GQCaeqd+eKVroZ3+l38ZUCKVCX9D1p2ubGty8suxUG4gda4JXaNgykqwOQQeRVq91Se8t0ilbhevvUuF9GVzFK+u3vLl5ZMnPC+wqpxTm6+1NrRJW0IHKPanEc0i/SpCBTYEeOtPQdqCKVaQyZM05kJGKah4P0xUife+vrVCGRIy3UU6MUkhfcp/mK9Y0i7S5gXBH3Q34V5aDg5PWuz8GyHyZnJyq5RR+tZz1RpTep0mo3reYMgbR0rmfEmuSWtoZYj85GxSPWtuZ1NsxkOEVSc9xivJPEWsPe332cOfKjPHbJp21KlKyKFxcNPM8kzbsnLGs5pNylUUKmamaaJsBgSOpxTAzOTsXArTRI5yeKQrH3TnqKmWXCn5izZ4NURIwkO/PHAp0k3ljoSfXFUFyW7JI+duSOgqlltw7gdKR7hnJHOT1Jp8YZiBg9KBbkhQSOe31qYfu48bvypnm+WNpT25qCaQbcfdPbHNCBjvM2/dYYpPtQ2hWHB74qkzMDmkVsYp3JZoeaCPmIK/wB6nQSmKUGJ+D1xVGNiJRjgEdKVkDAsjFSDmnuGx3ui6p5gMT8uOxbmujRRIoI4BHevIIbqWG6Vmb5h3r07QtRW/s02um8AZHcGokios1QuBjjNKR+lKQ+OGH4CmlHPWQ/gKhlDGOKibbyTmpJQIoy8kjAf54qEW7THdLvC9kz/ADoQELMX/wBUvH99hx+A71Fp9uv9l2zk5cp1Pb6elXWgXnJb86r6cAlmseT+7d0wT6Mf6YoJM64SBIneWRS5yAmOQfXNc3LK0ZJjcpAx5kPqO4robyJb7U5HHKxYiVMcM3Uk/TpVbXrC1i0W6fncq5XJ75pod7mO2p2eySEyrhfuNnOaghv4EDM0xZu20GufRCx+XJNbdhpaSwCRpdueq4561SgHO9kTr4nuoW/dTSBewPNXY/GUjqQ5kyBnIArmLuLyp3TspxSWkazXSIxwpODiqUELnZsaj4giviHMUpdRgMSOlZH2wliy5B9asanZJa7dhLE1nxqGJye1LkSY+ZsnbUpcDCjNKuqSk5KqMD1qi+AcZ5pp4IIBosSpvuXpNUuH4yB9BVb7XMyjL8E1D2xg/jR8u0fWm0h8zuWl4HvTGJ7HvTfOwOBSeZ1wAfwq73G2iU4xj+VRuQQeTSiTdwCM0j/dJzxnFAOS2R66kkTx4Cs7EfdHT8akRTgIzqQOhI5+lRwiRhvVdvrtYc1Iqvkliwz6muW1x2HbCB+8XKg8FV5FQyIhBYFcY/CpwGyAZWB+lEjhl2q8bAdjxz7UmhIypo1XkZx0qs4yx64HpWhcRHIBQDA7GqMkeMkfkKaGVm5PWonQkkjFWeD/APrqM4YkHimMgGSVBHAqZcAcZpAmDkHNScY9KOg9xmTUb4PTipcYFRtxg4/KjYCu3X2zSZpzDn8aZ+eaBD1HepAMCo0NT470dQGUvt7UMABR70MY9OmKmXrz2qFG4IIFSrmi4Djjd2xXVeDCxuZUaRBHt3YLc8deK5Q9eprpPDcKvDcOjYkJCY9qHsVHcteJtVj+wzQWzDkYLf1ryS5ZvOck5OevrXfeJoHtoJpDnYuAAD+tcDLyMge5pRu1qKoRRqXdYwCSTW/DpsixgKp5HNQ+GdPe8vQwXIU5Jr0uDTIwFyBke1Epa2RpSpcyuzyW6t5IJWLKeDVZmaRufqa9du/DNndqfMQcnqKwbnwMElcwNlWPQ9quMrilQaZwMMRZ2POAOBV+CBlAwMZ68dK7PTPCOwv5w46YpW8OushAAwOlX0EqLOIuYXDgdQKpSwtvPFdzPou4ZA+YcVBLoQKqVHOOanmH7BnDOGQ8imLEzglVJ/Cuwm0EvgBOlRpo7QjISk5k+wdzCs7J5ACynHrjpTLuF7abkHb3ru7W1j+zAbQpPUVm6tpyy89SBihTKlQ904lxhtwPeuk8GXTrrCQl8K4Oa56eIxTtGfWtHw3KkPiC1Z9wG/Hy9ats5krM9f2/nUM8qQgbgzOxwiKOWPtTmZm+WDLue5+6v1P9KIrJYnaRnZ5WGGcn9B6CosaEMVuxcTXGGl/hUfdT6ep96lYAHpUpjA9fzppjXOf60WEVmGOf61Uj/cXjIcbJzvQ/7QADD+R/Or7RrjoDUb2sdxb+Xjbg7lZeqn1FLcVjn9GX5nEnEivIGH+1vJ/rTfFWF0K5+6M4HP1HSnXsGoQXxkto1adhlyvKv2yQSMGuT8RXN/NPEt+EQgZVE6AZ6/WmtWLyMaDIkUr1BreWchawYDtuMdga0RJxWsRLcqX5DXLkCo7cN5i4HI9KmuV3OSBn8KfaJsBbpmmlYCTUmMiJ14zWYgKsfpWuSO/5VDcKNgwo6daYW6mOfXJqPBzxnGKmZCvUfjTcHv3qeXqIRANozSbcAc1KoG0ccd6aevXNFh20uM28cnv0pCcDJpfx6UZOemRmn6iaEB684qZldQpI4PI96i6dPxzWxazIbUo8RkyMfSndjsejqwyMkKQPusMj65FWAFzluc9SDSQl2QB/L6cqAADUoRzyqp9cZwK5bmlg8sEZDdOMk05oyFypRM+uCTTWiBPzKGz1C8Z/ChAcEm3A7DHPFJgV7iKTbu2qB6jj9azJBhjgYPpuzWvMUZf9ZMg/uspxWbMqBm2tk/nQgRUkDdWGQO+KZgenQdjUjg4wf0pvzL2x/I1WyAYQOhzmgLg8EE04k5GRjnjigDA60DIypx1qNwODU5HAGeagkGM4NICB+CelM6jpxUjAA00LzxTEOUdc5qQf1poXFPwfWhAIe9NPX6U88H3ppFMYq96nj6+9QL1NTrSAd0xW34am8u+kiOdjoTn0IrErU0u5jtIpJ2Qlidu4DoKTHHch8ayvHYCBo/mLZLk1wIbK7ccmus8RXUl9DMxYFFxtyO1cxBCW2sapXQpas7bwnGtvaNJjlzXWJc5FcfpLmKzUDHFayXJ29elc0r8x3017qOgjn3Zxz6VaSbYOVye9c2uo+UfapG1h5E2oBnvWtOWo5I25LkN93Ax1qtNMj4AKjPes1XeQHc4A9FpzECNQOnetua5mkOnkiQ54NUfORgef/rVHcuu4jOCagj2gZ5PtWLepokXd6bMjr3NV5CmMmo5JQqjBqhNcMeM0JDehLLchGxnjNVri4DgnPWqsku4nFQyn5ODTSMmzF1eEFvNHWqmlkjV7U7iP3q8j61p3i74WzUPhu2+0eJ7CI95Rn6VsjimvePZkQJGqjAwOx4prD/OTU5gGMY/8eNMMCDsP1pgQHAH/AOumNt9qnMSf7NMZE6Db+VJsRXYrz938qINrodvY1KUX2/Kkj7gDgc5qWhWIjEj3qZHRP615t44I/t0IvRY1H8z/AFr022G+/nP91VX+Z/rXlnjF/M8S3fPClVH4AU4vUGYC5FwSDirqk7Tk1QB/ee9XkII/xrRE+pKM+/SjGM+lIrZPWnZxVLcYbsCmStkDNIzCo5G4GDQBHIPlJGOlUyuW5NW2PyHr6VXbqMUPUQnRcCoiACvWpMYXjNNAHHqaLjshh6daQjjmnYx+eKCMCjqK43qDz17+lWbSR45kC9SR1FVyOTjqauabHv1GFT3cCn0A9XjaVkUb4ZFHUMRn9aeMKcAQDJ6eZtNMV3KgA2x4+75ZqQB8fMkar6qTj8q5UaEyLIMsVH4MDQcMvf6DiolUscIYjznBODT/AJlAJXd/utUbsAZl5xM2/uKoTjBzvB/CtB8hRlJFJHXGePrVORVYtgEk9CVosBmldxxtGe1MwQcgdqmk+ViCSretR7BnPf60wG89MH8aOcYGM+hFOOe36Uu049RimMibAUEhTUDjjOMe4qy2DypX6Gqz4HpkelCAgIHY0gByO9KcE80gPOD+dMRIPw4pwx+tMU5zT1PzZyKEAHgk0h4PSpMDHqKYw6UaDAfe461MBUI+92qZaQDucg96ASMgEgH0pTR0xQ32BEF+nmafIRnO08Vh26DC49K6GUeZbuh9CKx7aLBANA1ubFoxW1Ge5zVxZvk96qbdqKo9Kmt4yxyax6nbC60JyPMxzU9va56vgmligLYz+tadvbxAcHp1px3LkJDbxoMbiTTbgqcgcADqauERKhIIx7VmzFXfCsMH1rVuxC1Kpiibls+wpWt0VNw3AHtVgAJ8zYNRyzM4xwBS9C7mdJAfvbiB6VSnGMjmtho1IyxzVV0jJGcGp2JaMZlYDOMCq0kjZxWvMo56Vk3KFWyBVxZjPRFeVd0J4rR8DWgk8XREqCI4nf8ATH9apA7lx610fw6tVl167kYDEducbhnksK0W5zzR37Kg7KPw/wDr1GdmP4PyH+NXWiQd1/75FROqAYB/Qf4VRJTLIBwR+QphkUd/8/lVshR/EajYD1b86QFVnHqf8/hSx8qTg4z3qVgMdG/Ws/VfPGlXHkOY3A3bu4A6/pSEWrFf9IuT/tc1yPi3RNOi02+1D7MDck7jJuOclgPXFdL4ekaWw8123MwySeprM8ZjHhq9/wCA/wDoQpIXQ8j24JxVuM8YHaqvOfxqdSMZ7elaohFgfepjuFByeKaX29cVWlkL/l2plbaj5Ju2aYsnHJ7VC2e9L+dD2BMlZxtwKYcDpSDp04pRx2pIVxPTIoI4HApVOKXrj1zT6ARlB39egoZMipCM/XNB+6fWh6i0IduPWtLQY9+tW4PTdmkE1mI8fZDnHUyHrjrirXh1QNag44z3ouUlqeixIohyt3KxPTC9Pzp6xsp3efJ7kbeagRoguWOG74zUwlj4AYlh0BWua+hox/mNgkGV/wDgAyPrSh95IKsrep4ApquhPEfPUcYpvnKF+ZX55yjdPwNIRI6nB2SNuPcEEVFIJCvzAY784z+AqTIC8RZ3dajdI/vElT6qcUhqxRlTa2Vb9c1Fh15O0/Tip5ETJYBqi2sASnT3HSmmGpGRkhjijB//AFVIcEANtB9cGmlRkHdwO1HqMhc8VWfPpx9ankGfT6VXcc8kU/MRExDcgY+tNxzTmPvTecimgFAGaf8AhkU0A807bjuRSvqIlB9aQjH4U1QeT+VS4yOlNgMAy3Y1KBgc1GV55qRBxj8+KQD8A04Dil2njPpT1Hy4/pQNEYT0Hes2FNsrDHRq1scDP8qoSLsvGHqcjFJ7F09yyo3MB71ceeG0QbiM96z55PIiLjtXO3d7NO5+Yms4x5jolPlOsk8QwxghcfWq3/CTBgQGA+lcTIs796YUmHcVqoIydafY7oa3uHD5JpE1DLZ3YriY3nj7mr0N1JuAY1fKrFKq2dY2ose+aryakQetZBnJWqVzcMcBTQojlUdjbn1ogYzxWZLrL9Qenastg7dTTFg3HkmnoZSnJl8aszHlutOXUmz84JqiLUHsRzVuG0BOBn3pqxF5FyKQScqfwrvPhtCgutTmYqMIijOO5J7/AErhEt/Jbjv7V6n8M2t7fR7+e4keLzJgN4U7cKv97GB97vQtxvU6CR1JOG/LH+FQMwHdvwH/ANaraa1o93dm1tL4TTjPyIxJP09abKCCf3c34g1RLRnljno/6/4Uws2fuv8AkatN1/1b/j/+uom/65n8x/jSEVXLY+4/6/41zfiHVniieyihcs3+sPoCP1robu4FvHuMYLE4Vcjk1w2tSzGeVipMjEEleB0qRHR+FpgdP2su0qAuCe9QeNEz4YvPfb/6EK5Cz1G5sp1kXcBkZG7rXqEttDd24jnjWSNgMq4yD+FJMVuh4J5YB+8KXcoHJJr1668P2u8+XZwKPaMCsGbw+d5KwoOewrS4rWPPj8xyM0zyyRwG/Ku//sGQf8s1pp0SUfwCmpIDg/JbsrdPSm7CTt5zXenQ5SOFFYI0m4g1by2gcgsSuB1GKOZdxWMRYNqjzCU9tppvlneFXJz04rshoMrsPMClv7o6D/GqUuhXceoK3k5jyDuFCaBnPrZXJ58qnrp9z/cx+NdsuivgHP6Uv9jtgc0+ZDsjif7NucH5QKP7Mnx/D7V2p0k4xn9Kb/ZRH50cwaHHDSp8/eXP1rS0XTpLfVIpC4OD0Fbx0wdCTUlpYeXdq4zx6U+YFozYiJAGI4gD15yaeGQYw8ant8mcVVjdjFhWUfTipkZpDhSRj/aFc3qadSYM2DsnD/7OME04Ov8Ay3Jx0yRmq7NtPLt07dD+NKhLLjDe/U5/Cp0uMklbbzGny+w5FDb2TBfAPZlBFOjYR/cRiO+aZIxdtyqS2eWIxRcRUlUBuVB/3SKjOzrg/g3SrLl+nl59yABUTCXvGv0FFxkJAYAAcVHsUD7h57g1KyHAzH17Z6UwhuwUfWgPUrygY+6Pzqo4w3TFXJQQOdvNVHJz/wDWouBERxnFN/On4OM4H5U01XoIUfU0/HIxTBnrUg6d6BC4wcDmpFzjk0wDJp6Z7g4oGKVwfrT04HrRjJ/CnLHleaQiQcsKei5PqaaufbOKq6pMYLByGwxwBUt22NIR5pWNZbYSJuSeFyvVVfkVnXse26iOMZ4rn7RpYyWViD7Gr1vePNMiyHLA8Unex0+zgnoXb1N0OOKxGtwW6V0ckfmJj1rEvbKdSSpI+hpQktgqK7uQ/ZowPm2r7saoXYgjbaHRvoaja3ZSwmLEeuazzat5hyQVrdJHPKT7FtSD0NW7eMMQe9U44WMgZQABWxY2zSSKAMZpSsluVBXB7Z9mQOKpSRbSciu/h0fdp5cgZxXJanblHOBSTNJ07K5iOcHNRrOgPJ/SpZ4y5BBwB2qtJEHCqTgjvitNDnd+hcjuoW4Dc/StC1dWYEMD+NZNqhhRggBZ+MkVcgtxEQykgnrTSS1Em3ubEoBAxTBcXaxtardTJasctEHIUn3FRRMTweaZeSeXJGOx61Ld3c0SLAuZLSaKWFtuwgqR1B9a9Xs7q6utOtroLDKssYYhlCHPfnJ/kK8jlxJArZ610mkeKtRtrd9JtLRLiRFBickARjvu9Rk1Vx1E2kzuXuxEf30BiH947Sv5jOPxoa4Row8RjkB4Gx1OfyrznU/iDraOLeMQQOmQzxpncenG7NbPha+bXNNe4uiPtsblGuFyrkdR93Hr+lM529bG9Kn71nbaz4xnd09hxWPqmm3N5ECHBCMSML0BrSEN2HKx3CyR9/OQk/mMfyq7b/aNzFrdG4Awr/4ipaFc4AaS3lyySPnYPlUDqc16XChMCZ/uisi6sp2DmKxVcjJLyjH6A1pIL/YAWtYhjsGf+oosO5MyDvVOS3BJ4qUxStw93IfaNFUf1NMNpGT8ytJ/10ct+hoAoyNboSpkUsP4V+Y/kKqvI5J8u0lI9XIQfqc/pW15IUYACj0UYqMxLnpSsIxxHO/URx/7uXP8gKWO0RCSo+Y/eZjljWqY+KaY6VhWKAt1UcCgwD0q4ycUwqQegqgsVDEB2phjHGBVwrTNvFFhWKTRetRvEBV4p1780wwljgAkmqUdRWM50wPWp7S2JR5cY4wK6n/hEnttLF5qJKGQgRxDqfrUTWiCLy9uMDAxWnK47lxVzj4nb7uyND0I3U8yFdvzKVP8Sjn86qpK6RAIUXj5vlzkVPiSQZVkCdDkY5+lczXUsnUlyQGL5HKilwoHzoWHqWqNSU+Vnz7DpSbxuySVbsM9fzqAHl8HAGB+eaUngbgCf9oUpL45zgdzzTN2TyPxxQNDHIH8SD6KP8Kj2rt3DaTj6VIzE524z9KaS+MsTjtwBimCIyV6lRn2ppxjgZB74pWwfamgd+3uaGBXlHbOKqyfe61cl+7yRj161TcZPXP0pIRHjng/nTdpzTz+P5Uhp7AIPpTwOeO1NxjJp3Uf1oYh+cDpTs/MMk4NNJOOPyp6nBGaBko+8cfnTl49s0gwevp2NPC55APFAh6qrHr1FZ2sQM8CMMle9aUXOO+Ke8XnI0TZ5HQ9qT1LhLlkc+qCO0LKBuxWfbSkXsbE9+a1inls0cn3TkVR+zCGfJG4H7pqV2Ox90dNZ4dMnBqeeBHUAgc1nWM4RBmrLXI9aytZlqzRk32n/MQBkVlvp3zfdrqPOBXnpUeEJyUHWtU2Q6aZj2ukk/M3ArfsLFIiCRk1GGycVqWcZIBNKTbNYQUTUORprjBwB2rhdSGZua9IitwdPkJyeMYrg9WtiJDxV7WFJNpnPSQAtxUP2YdxVx8hsd6lCBhVq+5zctyilsO3FWEg5qYqFHSnIdxwBTeouVIWOLDiqep8yoo7DpWzEmFBI/GsyVAZXlxli3H0p2toJbhEpYQx456kVr+H51jsb+6IUSPIeR6AcVDptiZIZp5Gx8pAPviq9kxTT5o0GRljx3p26jbVzm7uRjIu5mbb6+5rpPBt49tNOM4Ryuc/jWdZaFdajdY8to1JyzEHCit+x0sWOY8b2zkttNUcnW531tbiRQVY468Vct4ikp5zwOoqjprYgTORwPatWEAynBz8o707BceykxvwPu0wIuOmTU+zKuP9ml2/KKQ0ViuOgphBNWCoHamleaVgK7LURUVZcYNQsKVgIiPaoyKmI4phHFOwiEjNMIGam2+lGymhFcr7UqQs7BVUsxOAAOa19M0O61SYJEhCfxSMMAV32k+H7PSUBRN83eVhz+HpV8ttwtc5HS/A9zcgSXr/AGdDztHLH/CuwsvD2mWCKIrWNmH8bjLE1qUU+bsVyo5bxfmR7OEdBuY/yrmXtSRzXV+IgDewk9fLP86564O0EVbWiKTPMokMkY4yo65NPK28PKKQx6gcmqwj3dSu7GRUkayc5P7wnsK4r6AT/OIy4Xy1zzjgmmCZiclUGeAOuff/APXUTxqxUncOfTgn2qQIvLYPPUnvSuA/O8nLBvXHHP0p2B/d6+/amiNT1TPfOOlNZssQO3vR6APYgAknA7cdai4bndj+VKWYr12n2NRndnAAzikArg8ZJNRt+dKckfcxTGzzxx60DI5R0/pVWQ89fyqxJwo4P41XfHpRcQwcCk4weO9B44oPJFNCE/CnY44o55GKdj1o2AVcfSkPJHOOelOAz+NS7QMZNIB64PWpU4bHRaYq5IIGOKkwAcU2AsSBATnr6VOn3S361EMDCgcZzzUsZIyM8Z6UrjKdxZmWIuFJK/fxUMFl5BWThu4Brct8AEA5J6kdKztQL2zlSPkPQjtUST6HVRmrcrMtztdyo289M9KFck8nmovN3yMNxdiSzNipFHze9BROoPHP4VJkAdKYCQOMVFNJgHHFNI1vYswsZLhY16nrXRxqkKqC3auVspxbu078cYFVrrxKv2gKX9qGm3oUpRirs72XWRDamBAMHnOa5fULlZDkjrWVJqcjKDuzkdaptdbf3krHaP1rRRuRKolsWLiMSJ5i8MvOPWo4m3KP51Db3iS5GTg+tSRABAe1V5GV03ckIB6c1Lbp83Pc1EME8Zq7bRgjNVElsuwxEwsAMkDNZcdm7vk556V3ngWG3bxDaLcxq8ZbGHGRnHGa76+0bw1Z6qz/ANlwGUncMB+v+70q3G5kpJHDWXh2ePwtZSzxMEZ3ZT6A4wT9cVjPoIhkby0AU5I2j/69eq3ObtfnQpGOi5c/zNZV1p8TAmMBT6YNPlRm3rc4PTbExyn5NvbpjFX7bSrcSBiu49+K2prby3zjp1qKLAk7UcpIR26x8Y4HSrtoFEhwOSKUIpGcge1OtgolYLzxzTYizjKv/u0gHSnj7zf7lIo4pAhrJnmmbcmrG2mFaLAVmXJqFl5q6UpjRE9BRy3C5RZc00rV0wMT90/lU1npc15dJCiEbjySOg9afIxXKdlYT304igjLsfTt9a7LS/CltahZLvE8vXb/AAj/ABrX0/T7fTbYRQrj+8x6sfepVczOQv3B1PrVLyHaxKiqihUUKo6ADAp1NZlRcscCkjbeu7HHal5jH0UmaazcGlYG0cx4pk8u7tyehQj9a5S5ueuTXQ+NmKR2soOfmKn8RXD3Ex55rdr3UKLucrEjGMbdg7hieKem4YBZfqPWo1YOikyLkDoMgD6VIjKW3PjaO+OlcBdxSHQkPtOO2MAUAliSBwPXtTd4YDAx/vd6aWPCkE/8BqbCJiTjCNuz1zSBQpxuz9O1H3cEn6AdRQAQDxyfWkMawDH79N4HLZx9KfhguCf/AK9MYZ6npzxTC4nVgM0w9afyenI/lTNpoewEbgkdCapuPm74q63THYVVlU8YpeQFdcj7xzzTutKAT1pMe1MB2OtOHH1poPPNKvByDQIeBzz0p4yWHNIMUqn5qALC4CgEYzTiMHioW3AgjPSpeBwe1OwADhl7/WhHIkPPWms2HUY96XkH3pAi/buUBHenStuGD93jOe9VYT8pyevFTthl68EYpDHzxxvZyQ7FUkcYGOa5/nNbyvlweuMVj3sfk3b4HyscipkjWk9bERbrmoTmQ4FSuMimqQvOaEzpRM8Aa2K9yK5yaxKzEkfnXSpKGGM9KglsjKxfpnnmri+456rQwjujAA/KkZg6bTyavXlo0ZG3DeuKp7ABzwa0ujBpoIUAORVtOmKgWMgCpEODjNKwKVtCeMZYVpwLgDNUYl3AVpRKMAVa0JZ0Og584vkDaOM11ivHlXJQt3yK5jStsVsvuc5xW/BIDxz/AJ/CqRk9zdiaF05MX/fApxWDHWP/AL5FWdBhW6mEbl9uO2f8K0tU04WqBoi5U/U/yFWiTnJFhwcFfyFZ8aINp7kelaUjMGPD/k1UAxCr8rdCO9LqIsArs/8ArVHG3+lbRnG3OfxpVkYgjafxpIyTcnKkfL3p7iLI++2f7lKq8ClQZlx/sGpY0yBxTSuITZxSFPatuy0SSdA8reWp6ccmtL+xrWO3YbC74+8TzTsloGpzFtaNcXKRD+I4+ldhb6fa2yBY4UyOrEZJqjZaVLb3STgqBj7p6itiiWmiGhAijoo/KjAFLUNzL5UJOcE9KlK7sUV7mcyOIY+5wcVaRVgix0AHJqpp6bwZyODwv09arapfEsLePqeuK25OaXIiL21ZOrte3GB/qlNWbi4S2QA49AKit1FlZAt97GTWKJ2vr0sx+VaqNPnfkib2RsRTlgc96Rp8cbgR7Vn3F0iOEFQRXSlyADVqjfUlsy/G5LaI0gPMbq36155NcBhkenWvSvEkXnaDdptzmMmvIBcnyuuPrVSj7qKgQozbQSoJA6Zpx3MOfyBqKMHaAVYD3qTb07L78ZrymbACWzuQjPc1KjspJAHT86jG0E9eacZFTgD6E1AhzNv5cc+opVUZ+8Oe1IGXHPA7c5pMqRjAA9qd+gxxzkADI6fWmt9SPalPGKbzjnBNACHjoce9MOCc9cetO28DJ4pmOeKEAhAYYAB/CoJFwOoyKshcITtz/Kq0mPT8KPQCEYI4BNNPbHIpxUkZJ/AUzkGkhDiOQe9KD1pvbpQODRoBIDjinjrUZOeKcDTAtKQcZoLE5479qamcfhTh0HakIjYkSAinnrntTWXL5z2xTgBwaBk8WMd6mz1OO9QxnHtT85JosAobtUV7B50LYHzryKkX7wx2qfIC880rDTsznix6Gq00mM1q6jbBHEijCv296yJV5ORSSOlSuiBtSEAyfwqvLqs1xw8xVfTpUkkKOeRUZVE4YDp1xV2Hr3IEnO47ZT/31URdS/zPmnskW77o5pVVAc7RV7g13FErrzHnA9asW7O5BcYNNRM4yOPSrMMfOcU7GdtS5BkYq/5uxevJqlH8vPpTg5Z8/lQ9BnaaeSLWL/dFbVvIRjgmsTR7iGewQhMug2sCe4rTWVQRgAVUUzB7nT6VqDWkgcA5HbP/ANetq/1Ca6sVm8n91nBII6/nXFwytxjbj6itOC+lS2kh+Qo45Bxx+laIkWSYEn5P1H+NUg2ONo4Y9xVa+vfL+ReWPYc1FbzTBCZOmc471LYGmp6cD86khR3uBtXIx2qjEJJ2GTgGuv0WwVYFJGTnrWlOPNqJjdL0eSa5V5lxEF55610kdnbxABYUGOnFPhQKtS0pPXQIrqFFJn5se1LUlAaKKQng0CY3JZsdhWXqTtPdRWiHBc4J9B3rUJCJmsaEPJqxuCPkQEA+9b0Vq5diGy/eXCWNnheMDAFY2lRm6vDO/IXmq+sXjTTiNTWnagWWnAngkZNbqPJT82S3dlfX9Q8uIxhutU9MxHZmZurc1galeNfakIg3BbHFad/crbWaxqcYFbxhaHIhMq3Gol70KDxmtK3di4yAB7VycEvm3efeukt5QuMk7vStbXWgnuX76QSW0kXGSpFeDXLmGeeIjlHI/Wvd4/n3fKM46mvDvEsP2fXb5P8ApoSK5qsUolR3HIRtUM2G7KDUnyDkZb601XDqN2xQOmBjFIsiqPvDnnFeQbseCMcAY9OmKkVowvPOf7vIqESY6c+tBCHaUYYJ4UHpUtCJSQo4Xj1pqFtoKmo2bDlflPtmpIs4PPGegoswJOScnAz2pOuf1FHQ8Hk0hH0pDEPvSE47jPp6UpGQM9KQjjFACDIB+lQzHGADyetSs+FA/PioWDZDH5c0JCKx/H8aDkYPFPYeh+tMwOoNABwOBSbsGk/i/lS45z3pAOFKKT15oHXrTAtIeBin1Aq7ip5yOlT5yKWghoOWI7UA/LSFf3m7vS8YPrQBNEak7moYSM/Sp1oGOHYU/d1x2pnfjrU9pbyXEzKg+p9KGtQKeoIXsyR1XB4rClGVJ/Our19lsLKG2ixumJ3t3IFcvIhGcVNrM6IKyKD8HpULdcZwKtSKMEgVWYgDPtVoplZwM9BSKQD71I3J460wDmqRLLMbZarMfX0qrH1HFWATjAqr21ETGTJwOlSA4XpUMYGKkY9qkfQ3fDs7AXC+jA10Ql3dehrmPDy4huH9Wx+QrehOQvNbpaGL3L6XTwxhN5BHSpxezAb/ADfkVcnHesyR1kbyzxjofSnXWYNLk+bkjrUa3EW4Z1ntVnUcv3PWrcZCKqmqcEXk2UMf91QDVjP3aqwGtYDfMuRXeaZHtgTjtXFaRHucGu6siEiXPYV02tTM2W2cRqKkU5UGs64m3SqimtBeEH0rKUbJDRAkm69dfRamBy7flVC0k3ahN9KtxvuklA7U5xsxJk9Qu/XFDzBYi49KowTF7csTyWNEYN6hJ3LFzKBDnPasGG8xHcuT8qfKPr3q/qc3l2hOcfLXLtcbdKXnmRi3612UKa5dSCewDXmoZP3QcmrviHUlgtvLU4JGKj0hBb2jTP1Nch4k1MzTPhuBwK1lrK/YVxdIlE2pPMeQnSrGq3LSN14rP0MbbZpPU0t3IWfjFWtIgT6cp8zca6W3iJG7NYOmLyCa343UkclVq1otBMvR4iTA+bPWvG/HEPl+JLrj72D+lezJgplTn615P8QYtmvFv70YNYT1ixx3MIBX+UnPbPalNuoAIZmPfjpSKNoAK4qZY0Iycq2eoNeNsdA6Mug+XjtkGghS2VQlh+tMSBMkhmx0xipFYRhgOPf1qGIYC4uXVhg7c4FOTuMd6jkbLFt3JGMmpFyF5H/16LdwHA44wCKM447e1OC8Z5xTT6Dp+tKwaCE54z/9am8epFKScf0pMY4NA7igfKcVCxDH2x+dSHO0DgVE6/vFYdAO1AiBgMcHnPSmkc1IyjOenoKYTxjIzQAzvnNA96XHpSE+lP0EOBODTev+NKBS4GT2pWAljPuan61XTrzU454ouAppoHf1pwU1PbWktwcRoTjvQgQyNcNVyC2mlz5cbH8K0rPRFQB5zuP90dK1ljVU2xgDHYUdCuUxbbSZzKjSKFjzyCa3/JSGPCIFB5IApYjlQO9SS88e1NFpJHG+LciWzPb5x/KsCQblrq/Fdvv01JwOYZAT9DxXKk/LzUTWptF6FNhiqskYPINXZB1OarMPamgZVIwaQAelSsvWmAc800yGOQc1MtRjsKkTgVQEoPHHFDNgZNIOnOKtadaG9vApH7tOXP8ASmlcG7I3tKhNvpibhhmBY+2avWr9iegqKU4XaMVHA37zaO/6CtnojIubS1yce1SX37xIoh0eQD8Kbb5eSSTt0FSSfPewIP4QzH+VShGiOVqWJNxANRJwtWbRSzirSBnR6PFgjNdL5gjjFYumx7UU4q9cy4jwDiu1QukjIkhkMt2vsa25X2Qk+1c/px/eg/rWreS7YaitG80gTKFlLi+mOe1X9Pk8yWY1gxTYuJPcVraQxDMf71XWhaLYk9SW4coki+lVLJt1qB3LH+dWNS+TefUVR0eQPCOfuu2fzpRX7u4upW8VXAgtWUHkLiudiBnhtox0CjNSeMb8OzKrd6qW1yIbVHPXbXTS92KTA09Vv1s9P8pDhiMV55qFyZptmSeea0dV1NpnZmYnHSsWzUz3aj1NS5agdXYr5GnrxziqjFnmx71dmYRwqgx06UaZamacNt75rTyFc19NtCkQOKvMVXHHIPFTRxmNQMUkiI4wcA1pdEvcjlu9i5Bwa888bq15Kt2OQi7Grrb5JzuVdpA6Y6ms250e4axle5IWMqeD1NZzV1YpaHCIoKAn86XAIwCc9iOaakm3nAx6EVMHBO4YDdAFHP4V4N9DYZ5ZGCTt+tOAVRwSfakYLyScnPc5NIWGCQCfpRfsBLjccEZHpSk7RxwM8bqiUEthvrxUi4zyTn6ZpDQEg+3uO9JkZpzEZ6jNHBGSaQCD6frTTx2pcdxz9KTABxmgBu4KMkH0phO49OKeQNvOcVGRg5BxRoFxjgAdaix7CpSBjiomoENbOOARSUp6dOKMAk0AA+lSCljjaRwqKWbpgCt+x0QDa9xyf7nb8aGwsZFtZz3DYijZvftWxBoT7cyyY9QorbigCqFUAY6AVMIz369jSKUTNg0i2XB2l8f3qvpH5QAVQF9AKf8AcYMOh4NTYyOOlFikkhq89elO8sKQw6HrQo29KkByhplDQmDUjqeD2xSZwM4qdFDx4qkBmXdqt1bS27/dkXH0rzy4hktZ5LeUYeM4P+NenyoRzXO+I9H+3w/aoB/pEY5Ufxj0+tEo3Q4yscQ5yDVd+vWpWBB5Bz3qNxWexo9SFutMNPbr0poBJpksUduKcvSjAFIivLKIol3O3QUxMljV5pFijGXY/lXV2NqllbCMfePLMe5qHS9LSxh3P80zfeb+lXZOeOlbxVkQ3dleR8c55PSltxl8dzxSEZYnnA6VesoMDcwoepPUuRqEjAAwO1JAvmXsj9lUKP50rsAKtabbF0ZgOpq+XohEmwmtnS7Q7gxFRQ2WWHFb1pAI1ziuilT1uyGy7CBGgxVW8mwMZqaSTavWsi6lyRXWtNSDa01uAat3sx8vGazrGTbEv0ovZvkPNS4XncRUSX9+3vXQ6eCkSEd65aFi1xj1rqofljiHtRX+FIS3E1aUm3J46VzmmXRWxlIJz5jVqatLiBwfSuY0+fGmTtn/AJaGnSjaFgMDxDcl5wCcktTLu7K2aIPTtWbq8++/xnoKhubkEZ7AYpNjK11Nn5Qa09Agy5lIyBWED5sw5rp7JhbWiqPvEc1MNZXAvSEzzbVrpdLtktYNzEA+9YmnRKgE0jbfduKl1TXYLG3JT95J2zwBXQrWuxM6EXTTNiNSfcU5lULmR0T6tXlkniK/uJDm4dVzwqnArTs9V84LG0hB7kmp510FY9Ht5NOVlkO12HGWrP1CeG6l2xiR3B4CLxXN3+sxWcCJCVLjqd3P5VAvjlreP9zAM92PejRa3FY4joBhMDsD3oWQRsCV3N0XsPrSRyKYwSp596lWJDGWK4JOM9a8NnQ+4AtyQBk96UDY2Ty3vSshiYxhzx7cUqj5ScDrS0FcXcduCOOuPWlyoB4OT2pgLYz6GhXQk4XnrmkBJsxxyM004zjJ+lNJLNu70mRjPNDQ7j26DB7etMPA5OKGHAzSdDQgYhYEcimMTmgmkb0JoEMLev6CoGJ3d/zpXOfoKbu6CgY4dwaeiF2CqMk9AKb3NdFoFlGYjdMAWJwvtSYki7pWnC2h3OB5rHnHb2rYWPFRwqBuH0NWAOBQaCAYpxHGRSNww9+KevTHpQMjYAnHZhTojxjuKRzgfTmgHEgI70xjyPzpVHWkP3qcvWjoA1TlT7VYjfaR6VX6Fh60SHCiqSEXJFBGaoSgxtVqKUtGKinAx9atDOS8Q6EJla9tUw/WVB39xXHleqnrXqBOw+1cr4g0ZICbqEhUfkr6H2qZx6lRl0ZyjL1pFUU+QHca2NO0MTRLNPJ8h5Cp1P1qEht2Mu3sp72QJCv1bsK6XT9MhsE4w0p+85FXI40hjCRIFQcACnjoTW0YJESlcQ1Ew64qU8EU2Qbfl/P3qmJESR75AorTwEjAqC3jA5J5NOmc4wO9KKEwyZG45FdXptp5dpGCOSM1zOnxCWaNT0ZgK7qOMDao6AV00Y3dyGSQQAc1aOEXnikXCrXMeJfEp0v91HEzTMOCegrruomdzYubjrWY8haQZPesTQNYuNRhnW4O50OQwGODWorneDU81wWp0FvIBGOar3cxbioUkO0CoZpDkVqmST2hzdqK6rfhkHotclpp3Xwrp9x80+wqKivYDJ1uUiJua5m0l26NK3q5rb8QSERNj0rlo5iugH/eNPZAcvdSGS+kPbNQTvnCjp60K+S7HrmqryEkjtWLkUtSzD8rjaMt2rr9JsFWIXN18x6hT0Fczo9uJrtMngc10Wr3zW1vsQYAHatKVrXZL7Ed7qC3F4VBwq9geK5jVLwyzkBsgcVC12+Wx3qi7FjyeayqVLlKJIkhLVZachMZNZwfAOak37hWbkOxOZmLEk5+tSeaWXtxVInnmnqxC4p81gaP/9k=');
/*!40000 ALTER TABLE `analyses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analysis_results`
--

DROP TABLE IF EXISTS `analysis_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analysis_results` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `skin_tone_id` int unsigned DEFAULT NULL,
  `detected_hex` char(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detected_r` tinyint unsigned NOT NULL,
  `detected_g` tinyint unsigned NOT NULL,
  `detected_b` tinyint unsigned NOT NULL,
  `undertone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `confidence` decimal(5,2) DEFAULT NULL,
  `original_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_analysis_skin_tone` (`skin_tone_id`),
  KEY `idx_analysis_session` (`session_id`),
  KEY `idx_analysis_user` (`user_id`),
  CONSTRAINT `fk_analysis_skin_tone` FOREIGN KEY (`skin_tone_id`) REFERENCES `skin_tones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_analysis_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analysis_results`
--

LOCK TABLES `analysis_results` WRITE;
/*!40000 ALTER TABLE `analysis_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `analysis_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `makeup_palettes`
--

DROP TABLE IF EXISTS `makeup_palettes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `makeup_palettes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `skin_tone_id` int unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_hex` char(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `brand_suggestion` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_palette_skin_tone` (`skin_tone_id`),
  CONSTRAINT `fk_palette_skin_tone` FOREIGN KEY (`skin_tone_id`) REFERENCES `skin_tones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `makeup_palettes`
--

LOCK TABLES `makeup_palettes` WRITE;
/*!40000 ALTER TABLE `makeup_palettes` DISABLE KEYS */;
/*!40000 ALTER TABLE `makeup_palettes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendation_logs`
--

DROP TABLE IF EXISTS `recommendation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendation_logs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `analysis_id` int unsigned NOT NULL,
  `palette_id` int unsigned NOT NULL,
  `area` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `was_applied` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_log_analysis` (`analysis_id`),
  KEY `idx_log_palette` (`palette_id`),
  CONSTRAINT `fk_log_analysis` FOREIGN KEY (`analysis_id`) REFERENCES `analysis_results` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_log_palette` FOREIGN KEY (`palette_id`) REFERENCES `makeup_palettes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendation_logs`
--

LOCK TABLES `recommendation_logs` WRITE;
/*!40000 ALTER TABLE `recommendation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommendation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skin_tones`
--

DROP TABLE IF EXISTS `skin_tones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skin_tones` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `hex_color` char(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rgb_r` tinyint unsigned NOT NULL,
  `rgb_g` tinyint unsigned NOT NULL,
  `rgb_b` tinyint unsigned NOT NULL,
  `undertone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skin_tones`
--

LOCK TABLES `skin_tones` WRITE;
/*!40000 ALTER TABLE `skin_tones` DISABLE KEYS */;
/*!40000 ALTER TABLE `skin_tones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Aron-John',NULL,'Castillo',NULL,'atcastillo@ccc.edu.ph','atcastillo@ccc.edu.ph','scrypt:32768:8:1$6kLSHHNfMfvUm6fI$21b865154dfb2671c78c70b54d1326b07b822b4b970bd871ec65a8e11917374d2efc7c41a0c8288b0d567b866b85bdf7e84f7dc5d362d53aeb449ff995715bfd',NULL,'2026-10-05 00:47:17','2026-10-05 00:47:17');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-05  9:05:11
