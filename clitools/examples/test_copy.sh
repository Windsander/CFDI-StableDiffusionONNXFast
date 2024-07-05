
bash ../../clitools/examples/action_sd_img2img.sh

#test-1: sd, img2img, positive
 -p " best quality, extremely detailed, (keep main character), A cat in the water at sunset" -m img2img -i ../../sd/io-test/input.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-2: sd, img2img, positive, negative
 -p " best quality, extremely detailed, (keep main character), A cat in the water at sunset" -n " worst quality, low quality, normal quality, lowres, watermark, monochrome, grayscale, ugly, blurry, Tan skin, dark skin, black skin, skin spots, skin blemishes, age spot, glans, disabled, bad anatomy, amputation, bad proportions, twins, missing body, fused body, extra head, poorly drawn face, bad eyes, deformed eye, unclear eyes, cross-eyed, long neck, malformed limbs, extra limbs, extra arms, missing arms, bad tongue, strange fingers, mutated hands, missing hands, poorly drawn hands, extra hands, fused hands, connected hand, bad hands, missing fingers, extra fingers, 4 fingers, 3 fingers, deformed hands, extra legs, bad legs, many legs, more than two legs, bad feet, extra feet" -m img2img -i ../../sd/io-test/input.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-3: sd, img2img, positive, 3
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 3 -v

#test-4: sd, txt2img, positive, 15
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-5: sd-turbo, img2img, positive, 3
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input-test.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 1024 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-6: sd-turbo, txt2img, positive, 15
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 1024 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-7: sd-turbo, txt2img, positive, 2, guide=1.0
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 1024 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 2 -v

#test-7(2): sd-turbo, img2img, positive, 1, guide=1.0
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input-test.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 1024 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 1 -v

###########################################################

#test-8: sd-v1.5, img2img, positive, 3
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input-test.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-official-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-official-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-dictionary/vocab.txt --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 3 -v

#test-9: sd-v1.5, txt2img, positive, negative, 15
 -p "A cat in the water at sunset" -n "worst quality"  -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-official-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-official-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-base-model/onnx-official-sd-v15/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-10: sd-v1.5, txt2img, positive, 15, guide=7.5, euler_a
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-official-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-official-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-base-model/onnx-official-sd-v15/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 7.5 --steps 15 -v

#test-11(1): sd-v1.5, txt2img, positive, 2, guide=1.0, euler_a
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-official-sd-v15/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-official-sd-v15/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-official-sd-v15/vae_decoder/model.onnx --dict ../../sd/sd-base-model/onnx-official-sd-v15/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 2 -v

#test-11(2): sd-v1.5, img2img, positive, 15, guide=1.0, euler
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input-test.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 15 -v

#test-11(3): sd-v1.5, txt2img, positive, 15, guide=1.0, euler
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 15 -v

#test-12(1): sd-v1.5, txt2img, positive, 2, guide=1.0 , merges.txt
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --merges ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/merges.txt --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler euler_a --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 2 -v

#test-12(1): sd-v1.5, txt2img, positive, 5, guide=1.0 , merges.txt, lms
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --merges ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/merges.txt --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler lms --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 1 -v

#test-12(2): sd-v1.5, txt2img, positive, 5, guide=1.0 , merges.txt, lms
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input-test.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --merges ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/merges.txt --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler lms --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 3 -v

#test-13(1): sd-v1.5, txt2img, positive, 4, guide=1.0 , merges.txt, lcm
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --merges ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/merges.txt --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler lcm --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 4 -v

#test-13(2): sd-v1.5, img2img, positive, 4, guide=1.0 , merges.txt, lcm
 -p "A cat in the water at sunset" -m img2img -i ../../sd/io-test/input-test.png -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 768 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --merges ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/merges.txt --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler lcm --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 4 -v

#test-14(1): sd-v1.5, img2img, positive, 4, guide=1.0 , merges.txt, heun
 -p "A cat in the water at sunset" -m txt2img -o ../../sd/io-test/output.png -w 512 -h 512 -c 3 --seed 15.0 --dims 1024 --clip ../../sd/sd-base-model/onnx-sd-turbo/text_encoder/model.onnx --unet ../../sd/sd-base-model/onnx-sd-turbo/unet/model.onnx --vae-encoder ../../sd/sd-base-model/onnx-sd-turbo/vae_encoder/model.onnx --vae-decoder ../../sd/sd-base-model/onnx-sd-turbo/vae_decoder/model.onnx --merges ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/merges.txt --dict ../../sd/sd-base-model/onnx-sd-turbo/tokenizer/vocab.json --beta-start 0.00085 --beta-end 0.012 --beta scaled_linear --alpha cos --scheduler heun --predictor epsilon --tokenizer bpe --train-steps 1000 --token-idx-num 49408 --token-length 77 --token-border 1.0 --gain 1.1 --decoding 0.18215 --guidance 1.0 --steps 1 -v
